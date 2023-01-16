//
//  FileStorageDriverContext.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Logging
import NIO

///
/// Driver context object
///
public struct FileStorageDriverContext {

    /// Driver configuration
    public let configuration: FileStorageDriverConfiguration
    
    /// Logger instance
    public let logger: Logger
    
    /// The event EventLoop used to execute events
    public let eventLoop: EventLoop
    
    ///
    /// Initializes a new driver context
    ///
    /// - Parameters:
    ///     - configuration: The driver configuration
    ///     - logger: The logger instance
    ///     - eventLoop: The event loop used to execute events
    ///
    public init(
        configuration: FileStorageDriverConfiguration,
        logger: Logger,
        eventLoop: EventLoop
    ) {
        self.configuration = configuration
        self.logger = logger
        self.eventLoop = eventLoop
    }
}

