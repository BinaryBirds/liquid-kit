//
//  FileStorageID.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

/// a hashable, and codable file storage identifier object
public struct FileStorageID: Hashable, Codable {
    
    /// string representation of the identifier
    public let string: String
    
    /// init a fs identifier using a string 
    public init(string: String) {
        self.string = string
    }
}
