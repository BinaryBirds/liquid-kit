//
//  FileStorageDriverConfigurationFactory.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

///
/// Abstract configuration factory, to hide underlying driver configs
///
public struct FileStorageDriverConfigurationFactory {

    /// Creates a new abstract configuration object
    public let make: () -> FileStorageDriverConfiguration

    ///
    /// Initialize the configuration factory with a make block to hide driver config details
    ///
    /// - Parameters:
    ///     - make: The function that returns a `FileStorageDriverConfiguration`
    ///
    public init(
        _ make: @escaping () -> FileStorageDriverConfiguration
    ) {
        self.make = make
    }
}
