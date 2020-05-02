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
        self.use(factory.make(), as: id, isDefault: isDefault)
    }
    
    public func use(_ config: FileStorageConfiguration, as id: FileStorageID, isDefault: Bool? = nil) {
        self.lock.lock()
        defer { self.lock.unlock() }
        self.configurations[id] = config
        if isDefault == true || (self.defaultID == nil && isDefault != false) {
            self.defaultID = id
        }
    }

    public func `default`(to id: FileStorageID) {
        self.lock.lock()
        defer { self.lock.unlock() }
        self.defaultID = id
    }
    
    public func configuration(for id: FileStorageID? = nil) -> FileStorageConfiguration? {
        self.lock.lock()
        defer { self.lock.unlock() }
        return self.configurations[id ?? self._requireDefaultID()]
    }
    
    public func fileStorage(_ id: FileStorageID? = nil, logger: Logger, on eventLoop: EventLoop) -> FileStorage? {
        self.lock.lock()
        defer { self.lock.unlock() }
        let id = id ?? self._requireDefaultID()
        var logger = logger
        logger[metadataKey: "file-storage-id"] = .string(id.string)
        let configuration = self._requireConfiguration(for: id)
        let context = FileStorageContext(
            configuration: configuration,
            logger: logger,
            eventLoop: eventLoop
        )
        let driver: FileStorageDriver
        if let existing = self.drivers[id] {
            driver = existing
        } else {
            let new = configuration.makeDriver(for: self)
            self.drivers[id] = new
            driver = new
        }
        return driver.makeStorage(with: context)
    }

    public func reinitialize(_ id: FileStorageID? = nil) {
        self.lock.lock()
        defer { self.lock.unlock() }
        let id = id ?? self._requireDefaultID()
        if let driver = self.drivers[id] {
            self.drivers[id] = nil
            driver.shutdown()
        }
    }

    public func shutdown() {
        self.lock.lock()
        defer { self.lock.unlock() }
        for driver in self.drivers.values {
            driver.shutdown()
        }
        self.drivers = [:]
    }

    private func _requireConfiguration(for id: FileStorageID) -> FileStorageConfiguration {
        guard let configuration = self.configurations[id] else {
            fatalError("No file storage configuration registered for \(id).")
        }
        return configuration
    }

    private func _requireDefaultID() -> FileStorageID {
        guard let id = self.defaultID else {
            fatalError("No default file storage configured.")
        }
        return id
    }
}
