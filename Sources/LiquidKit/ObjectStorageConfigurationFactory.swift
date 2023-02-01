//
//  ObjectStorageConfigurationFactory.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

///
/// Abstract configuration factory, to hide underlying driver configs
///
public struct ObjectStorageConfigurationFactory {

    /// Creates a new abstract configuration object
    public let make: () -> ObjectStorageConfiguration

    ///
    /// Initialize the configuration factory with a make block to hide driver config details
    ///
    /// - Parameters:
    ///     - make: The function that returns a `FileStorageDriverConfiguration`
    ///
    public init(
        _ make: @escaping () -> ObjectStorageConfiguration
    ) {
        self.make = make
    }
}
