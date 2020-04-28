//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO
import Logging
import Foundation

public struct FileStorageContext {
    public let configuration: FileStorageConfiguration
    public let logger: Logger
    public let eventLoop: EventLoop
    
    public init(configuration: FileStorageConfiguration,
                logger: Logger,
                eventLoop: EventLoop) {
        self.configuration = configuration
        self.logger = logger
        self.eventLoop = eventLoop
    }
}

