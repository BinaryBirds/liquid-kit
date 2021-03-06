//
//  FileStorageConfiguration.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// fs configuration protocol
public protocol FileStorageConfiguration {

    /// creates a new driver using the FileStorages object, driver will be stored in that storage
    func makeDriver(for: FileStorages) -> FileStorageDriver
}
