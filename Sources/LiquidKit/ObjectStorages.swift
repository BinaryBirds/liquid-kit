//
//  ObjectStorages.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Logging
import NIO
import NIOConcurrencyHelpers

///
/// Shared driver factory storage
///
public final class ObjectStorages {

    // MARK: - private
    
    /// Identifier of the default driver
    private var defaultID: ObjectStorageID?
    
    /// Identifiers and configuration pairs
    private var configurations: [ObjectStorageID: ObjectStorageConfiguration]

    /// Running drivers, access to this variable must be synchronized
    private var drivers: [ObjectStorageID: ObjectStorageDriver]

    /// Lock, to synchronize driver accesses across threads
    private var lock: NIOLock
    
    // MARK: - public
    
    /// Non-blocking fileio reference
    public let fileio: NonBlockingFileIO
    
    /// The byte buffer allocator instance
    public let byteBufferAllocator: ByteBufferAllocator
    
    /// Shared event loop group reference.
    public let eventLoopGroup: EventLoopGroup

    ///
    /// Initialize a new object
    ///
    /// - Parameters:
    ///     - eventLoopGroup: The event loop group
    ///     - fileio: The file io instance
    ///
    public init(
        eventLoopGroup: EventLoopGroup,
        byteBufferAllocator: ByteBufferAllocator,
        fileio: NonBlockingFileIO
    ) {
        self.eventLoopGroup = eventLoopGroup
        self.byteBufferAllocator = byteBufferAllocator
        self.fileio = fileio

        self.configurations = [:]
        self.drivers = [:]
        self.lock = .init()
    }
}

private extension ObjectStorages {
    
    ///
    /// Returns the existing configuration for an identifier otherwise, this call results in a fatal error
    ///
    func requireConfiguration(
        for id: ObjectStorageID
    ) -> ObjectStorageConfiguration {
        guard let configuration = configurations[id] else {
            fatalError("Can't find configuration for file storage `\(id)`.")
        }
        return configuration
    }

    ///
    /// Returns the existing default driver identifier, otherwise call results in a fatal error
    ///
    func requireDefaultID() -> ObjectStorageID {
        guard let id = defaultID else {
            fatalError("Can't find default file storage.")
        }
        return id
    }
}

public extension ObjectStorages {
    
    ///
    /// The available configuration identifiers
    ///
    func ids() -> Set<ObjectStorageID> {
        return lock.withLock { Set(configurations.keys) }
    }
    
    ///
    /// Register a configuration using a factory object with an id, optionally mark it as default configuration
    ///
    func use(
        _ factory: ObjectStorageConfigurationFactory,
        as id: ObjectStorageID,
        isDefault: Bool? = nil
    ) {
        use(factory.make(), as: id, isDefault: isDefault)
    }
    
    ///
    /// Use a file configuration with an id, optionally mark it as default configuration
    ///
    func use(
        _ config: ObjectStorageConfiguration,
        as id: ObjectStorageID,
        isDefault: Bool? = nil
    ) {
        lock.lock()
        defer { lock.unlock() }
        configurations[id] = config
        if isDefault == true || (defaultID == nil && isDefault != false) {
            defaultID = id
        }
    }

    ///
    /// Sets the default driver for a given identifier
    ///
    func `default`(
        to id: ObjectStorageID
    ) {
        lock.lock()
        defer { lock.unlock() }
        defaultID = id
    }
    
    ///
    /// Returns the configuration for a given identifier
    ///
    /// - Parameters:
    ///     - for: The identifier of requested the dirver config, if `nil` it'll use the default identifier
    ///
    /// - Returns:
    ///     The configuration for the driver
    ///
    func configuration(
        for id: ObjectStorageID? = nil
    ) -> ObjectStorageConfiguration? {
        lock.lock()
        defer { lock.unlock() }
        return configurations[id ?? requireDefaultID()]
    }
    
    ///
    /// Returns a driver for a given identifier using a logger and an event loop object
    ///
    func make(
        _ id: ObjectStorageID? = nil,
        logger: Logger,
        on eventLoop: EventLoop
    ) -> ObjectStorage? {
        lock.lock()
        defer { lock.unlock() }
        let id = id ?? requireDefaultID()
        var logger = logger
        logger[metadataKey: "object-storage-id"] = .string(id.string)
        let configuration = requireConfiguration(for: id)
        let context = ObjectStorageContext(
            configuration: configuration,
            logger: logger,
            eventLoop: eventLoop
        )
        let driver: ObjectStorageDriver
        if let existing = drivers[id] {
            driver = existing
        }
        else {
            let new = configuration.make(using: self)
            drivers[id] = new
            driver = new
        }
        return driver.make(using: context)
    }

    ///
    /// Reinitialize a driver for a given identifier
    ///
    func reinitialize(
        _ id: ObjectStorageID? = nil
    ) {
        lock.lock()
        defer { lock.unlock() }
        let id = id ?? requireDefaultID()
        if let driver = drivers[id] {
            drivers[id] = nil
            driver.shutdown()
        }
    }

    ///
    /// Shuts down all the initialized drivers
    ///
    func shutdown() {
        lock.lock()
        defer { lock.unlock() }
        for driver in drivers.values {
            driver.shutdown()
        }
        drivers = [:]
    }
}
