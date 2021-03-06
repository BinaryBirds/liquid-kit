//
//  FileStorageContext.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// file storage context object
public struct FileStorageContext {
    
    /// file storage configuration
    public let configuration: FileStorageConfiguration
    
    /// logger
    public let logger: Logger
    
    /// event loop
    public let eventLoop: EventLoop
    
    /// public init method
    public init(configuration: FileStorageConfiguration,
                logger: Logger,
                eventLoop: EventLoop) {
        self.configuration = configuration
        self.logger = logger
        self.eventLoop = eventLoop
    }
}

