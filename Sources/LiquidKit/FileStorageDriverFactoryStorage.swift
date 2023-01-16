//
//  FileStorageDriverFactoryStorage.swift
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
public final class FileStorageDriverFactoryStorage {

    // MARK: - private
    
    /// Identifier of the default driver
    private var defaultID: FileStorageDriverID?
    
    /// Identifiers and configuration pairs
    private var configurations: [FileStorageDriverID: FileStorageDriverConfiguration]

    /// Running drivers, access to this variable must be synchronized
    private var drivers: [FileStorageDriverID: FileStorageDriverFactory]

    /// Lock, to synchronize driver accesses across threads
    private var lock: NIOLock
    
    // MARK: - public
    
    /// Non-blocking fileio reference
    public let fileio: NonBlockingFileIO
    
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
        fileio: NonBlockingFileIO
    ) {
        self.eventLoopGroup = eventLoopGroup
        self.fileio = fileio
        self.configurations = [:]
        self.drivers = [:]
        self.lock = .init()
    }
}

private extension FileStorageDriverFactoryStorage {
    
    ///
    /// Returns the existing configuration for an identifier otherwise, this call results in a fatal error
    ///
    func requireConfiguration(
        for id: FileStorageDriverID
    ) -> FileStorageDriverConfiguration {
        guard let configuration = configurations[id] else {
            fatalError("Can't find configuration for file storage `\(id)`.")
        }
        return configuration
    }

    ///
    /// Returns the existing default driver identifier, otherwise call results in a fatal error
    ///
    func requireDefaultID() -> FileStorageDriverID {
        guard let id = defaultID else {
            fatalError("Can't find default file storage.")
        }
        return id
    }
}

public extension FileStorageDriverFactoryStorage {
    
    ///
    /// The available configuration identifiers
    ///
    func ids() -> Set<FileStorageDriverID> {
        return lock.withLock { Set(configurations.keys) }
    }
    
    ///
    /// Register a configuration using a factory object with an id, optionally mark it as default configuration
    ///
    func use(
        _ factory: FileStorageDriverConfigurationFactory,
        as id: FileStorageDriverID,
        isDefault: Bool? = nil
    ) {
        use(factory.make(), as: id, isDefault: isDefault)
    }
    
    ///
    /// Use a file configuration with an id, optionally mark it as default configuration
    ///
    func use(
        _ config: FileStorageDriverConfiguration,
        as id: FileStorageDriverID,
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
        to id: FileStorageDriverID
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
        for id: FileStorageDriverID? = nil
    ) -> FileStorageDriverConfiguration? {
        lock.lock()
        defer { lock.unlock() }
        return configurations[id ?? requireDefaultID()]
    }
    
    ///
    /// Returns a driver for a given identifier using a logger and an event loop object
    ///
    func makeDriver(
        _ id: FileStorageDriverID? = nil,
        logger: Logger,
        on eventLoop: EventLoop
    ) -> FileStorageDriver? {
        lock.lock()
        defer { lock.unlock() }
        let id = id ?? requireDefaultID()
        var logger = logger
        logger[metadataKey: "file-storage-id"] = .string(id.string)
        let configuration = requireConfiguration(for: id)
        let context = FileStorageDriverContext(
            configuration: configuration,
            logger: logger,
            eventLoop: eventLoop
        )
        let driver: FileStorageDriverFactory
        if let existing = drivers[id] {
            driver = existing
        }
        else {
            let new = configuration.makeDriverFactory(using: self)
            drivers[id] = new
            driver = new
        }
        return driver.makeDriver(using: context)
    }

    ///
    /// Reinitialize a driver for a given identifier
    ///
    func reinitialize(
        _ id: FileStorageDriverID? = nil
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
