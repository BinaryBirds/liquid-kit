//
//  ObjectStorageDriver.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

///
/// Driver factory, that can create a new driver using a given context
///
public protocol ObjectStorageDriver {

    ///
    /// Creates a driver with a given context
    ///
    /// - Parameters:
    ///     - using: The driver context
    ///
    /// - Returns:
    ///     The driver
    ///
    func make(
        using context: ObjectStorageContext
    ) -> ObjectStorage

    ///
    /// Shuts down the driver
    ///
    func shutdown()
}
