//
//  ObjectStorageID.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

///
/// A Hashable, and Codable file storage driver identifier object
///
public struct ObjectStorageID: Hashable, Codable {
    
    /// String representation of the identifier
    public let string: String
    
    ///
    /// Init a fs identifier using a string
    ///
    /// - Parameters:
    ///     - string: The string used to uniquely identify the driver
    ///
    public init(string: String) {
        self.string = string
    }
}
