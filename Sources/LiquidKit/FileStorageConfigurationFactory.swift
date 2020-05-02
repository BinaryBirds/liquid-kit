//
//  FileStorageConfigurationFactory.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

public struct FileStorageConfigurationFactory {

    public let make: () -> FileStorageConfiguration

    public init(make: @escaping () -> FileStorageConfiguration) {
        self.make = make
    }
}
