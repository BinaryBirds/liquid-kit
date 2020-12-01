//
//  FileStorages.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import class NIOConcurrencyHelpers.Lock

public final class FileStorages {
//    public let eventLoopGroup: EventLoopGroup
//    public let threadPool: NIOThreadPool
    public let fileio: NonBlockingFileIO

    private var defaultID: FileStorageID?
    private var configurations: [FileStorageID: FileStorageConfiguration]

    // Currently running file storage drivers.
    // Access to this variable must be synchronized.
    private var drivers: [FileStorageID: FileStorageDriver]

    // Synchronize access across threads.
    private var lock: Lock
    
    public init(fileio: NonBlockingFileIO) {
        self.fileio = fileio
        self.configurations = [:]
        self.drivers = [:]
        self.lock = .init()
    }
    
    public func use(_ factory: FileStorageConfigurationFactory, as id: FileStorageID, isDefault: Bool? = nil) {
        use(factory.make(), as: id, isDefault: isDefault)
    }
    
    public func use(_ config: FileStorageConfiguration, as id: FileStorageID, isDefault: Bool? = nil) {
        lock.lock()
        defer { lock.unlock() }
        configurations[id] = config
        if isDefault == true || (defaultID == nil && isDefault != false) {
            defaultID = id
        }
    }

    public func `default`(to id: FileStorageID) {
        lock.lock()
        defer { lock.unlock() }
        defaultID = id
    }
    
    public func configuration(for id: FileStorageID? = nil) -> FileStorageConfiguration? {
        lock.lock()
        defer { lock.unlock() }
        return configurations[id ?? _requireDefaultID()]
    }
    
    public func fileStorage(_ id: FileStorageID? = nil, logger: Logger, on eventLoop: EventLoop) -> FileStorage? {
        lock.lock()
        defer { lock.unlock() }
        let id = id ?? _requireDefaultID()
        var logger = logger
        logger[metadataKey: "file-storage-id"] = .string(id.string)
        let configuration = _requireConfiguration(for: id)
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

    public func reinitialize(_ id: FileStorageID? = nil) {
        lock.lock()
        defer { lock.unlock() }
        let id = id ?? _requireDefaultID()
        if let driver = drivers[id] {
            drivers[id] = nil
            driver.shutdown()
        }
    }

    public func shutdown() {
        lock.lock()
        defer { lock.unlock() }
        for driver in drivers.values {
            driver.shutdown()
        }
        drivers = [:]
    }

    private func _requireConfiguration(for id: FileStorageID) -> FileStorageConfiguration {
        guard let configuration = configurations[id] else {
            fatalError("No file storage configuration registered for \(id).")
        }
        return configuration
    }

    private func _requireDefaultID() -> FileStorageID {
        guard let id = defaultID else {
            fatalError("No default file storage configured.")
        }
        return id
    }
}
