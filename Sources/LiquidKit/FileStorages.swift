//
//  FileStorages.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import class NIOConcurrencyHelpers.Lock

/// FileStorages object to store fs drivers, configurations and identifiers and provide access to them
public final class FileStorages {
    
    /// non-blocking fileio reference
    public let fileio: NonBlockingFileIO

    // MARK: - private
    
    /// identifier of the default fs driver
    private var defaultID: FileStorageID?
    
    /// fs identifiers and configuration pairs
    private var configurations: [FileStorageID: FileStorageConfiguration]

    /// Running fs drivers, access to this variable must be synchronized.
    private var drivers: [FileStorageID: FileStorageDriver]

    /// Lock, to synchronize fs access across threads.
    private var lock: Lock
    
    /// returns an existing configuration for an identifier otherwise call results in a fatal error
    private func requireConfiguration(for id: FileStorageID) -> FileStorageConfiguration {
        guard let configuration = configurations[id] else {
            fatalError("No file storage configuration registered for \(id).")
        }
        return configuration
    }

    /// returns the existing fs identifier, otherwise call results in a fatal error
    private func requireDefaultID() -> FileStorageID {
        guard let id = defaultID else {
            fatalError("No default file storage configured.")
        }
        return id
    }
    
    // MARK: - public api
    
    public func ids() -> Set<FileStorageID> {
        return self.lock.withLock { Set(self.configurations.keys) }
    }
    
    /// init a FileStorages object with a fileio argument
    public init(fileio: NonBlockingFileIO) {
        self.fileio = fileio
        self.configurations = [:]
        self.drivers = [:]
        self.lock = .init()
    }
    
    /// register a ffile storage configuration using a factory object with a file storage id, optionally mark as default driver configuration
    public func use(_ factory: FileStorageConfigurationFactory, as id: FileStorageID, isDefault: Bool? = nil) {
        use(factory.make(), as: id, isDefault: isDefault)
    }
    
    /// use a file storage configuration with a file storage id, optionally mark as default configuration
    public func use(_ config: FileStorageConfiguration, as id: FileStorageID, isDefault: Bool? = nil) {
        lock.lock()
        defer { lock.unlock() }
        configurations[id] = config
        if isDefault == true || (defaultID == nil && isDefault != false) {
            defaultID = id
        }
    }

    /// returns the default file storage for a given fs identifier
    public func `default`(to id: FileStorageID) {
        lock.lock()
        defer { lock.unlock() }
        defaultID = id
    }
    
    /// returns the configuration for a given fs identifier
    public func configuration(for id: FileStorageID? = nil) -> FileStorageConfiguration? {
        lock.lock()
        defer { lock.unlock() }
        return configurations[id ?? requireDefaultID()]
    }
    
    /// returns a file storage for a given identifier using a logger and an event loop object
    public func fileStorage(_ id: FileStorageID? = nil, logger: Logger, on eventLoop: EventLoop) -> FileStorage? {
        lock.lock()
        defer { lock.unlock() }
        let id = id ?? requireDefaultID()
        var logger = logger
        logger[metadataKey: "file-storage-id"] = .string(id.string)
        let configuration = requireConfiguration(for: id)
        let context = FileStorageContext(
            configuration: configuration,
            logger: logger,
            eventLoop: eventLoop
        )
        let driver: FileStorageDriver
        if let existing = drivers[id] {
            driver = existing
        }
        else {
            let new = configuration.makeDriver(for: self)
            drivers[id] = new
            driver = new
        }
        return driver.makeStorage(with: context)
    }

    /// reinitialize a file storage driver for a given identifier
    public func reinitialize(_ id: FileStorageID? = nil) {
        lock.lock()
        defer { lock.unlock() }
        let id = id ?? requireDefaultID()
        if let driver = drivers[id] {
            drivers[id] = nil
            driver.shutdown()
        }
    }

    /// shuts down all the initialized fs drivers
    public func shutdown() {
        lock.lock()
        defer { lock.unlock() }
        for driver in drivers.values {
            driver.shutdown()
        }
        drivers = [:]
    }

}
