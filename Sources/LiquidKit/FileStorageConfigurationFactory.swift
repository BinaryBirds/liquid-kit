//
//  FileStorageConfigurationFactory.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// file storage configuration factory
public struct FileStorageConfigurationFactory {

    /// creates a new fs configuration object
    public let make: () -> FileStorageConfiguration

    /// init the fs factory with a make block
    public init(make: @escaping () -> FileStorageConfiguration) {
        self.make = make
    }
}
