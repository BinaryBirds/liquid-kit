//
//  FileStorageDriverFactory.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

///
/// Driver factory, that can create a new driver using a given context
///
public protocol FileStorageDriverFactory {

    ///
    /// Creates a driver with a given context
    ///
    /// - Parameters:
    ///     - using: The driver context
    ///
    /// - Returns:
    ///     The driver
    ///
    func makeDriver(
        using context: FileStorageDriverContext
    ) -> FileStorageDriver

    ///
    /// Shuts down the driver
    ///
    func shutdown()
}
