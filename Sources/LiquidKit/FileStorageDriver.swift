//
//  FileStorageDriver.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// FileStorageDriver protocol to create a FileStorage with a given context
public protocol FileStorageDriver {

    /// creates a FileStorage object with a given context
    func makeStorage(with context: FileStorageContext) -> FileStorage
    
    /// shuts down the driver
    func shutdown()
}
