//
//  ObjectStorageError.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

///
/// Driver errors
///
public enum ObjectStorageError: Error {

    /// Key does not exist
    case keyNotExists
    
    /// Invalid checksum
    case invalidChecksum
    
    /// Invalid response
    case invalidResponse
}
