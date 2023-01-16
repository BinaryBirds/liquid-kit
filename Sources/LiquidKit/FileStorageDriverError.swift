//
//  FileStorageDriverError.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation

///
/// Driver errors
///
public enum FileStorageDriverError {

    /// Key not exists error
    case keyNotExists
}

extension FileStorageDriverError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .keyNotExists:
            return "Key not exists"
        }
    }
}
