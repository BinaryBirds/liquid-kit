//
//  ObjectStorageConfiguration.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

///
/// Driver configuration protocol for creating abstract driver factory objects
///
public protocol ObjectStorageConfiguration {

    ///
    /// Creates a new driver factory using the factory storage object
    ///
    /// - Parameters:
    ///     - using: The driver factory storage instance
    ///
    /// - Returns:
    ///     The driver factory
    ///
    func make(
        using: ObjectStorages
    ) -> ObjectStorageDriver
}

