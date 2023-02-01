//
//  ObjectStorageError.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation

///
/// Driver errors
///
public enum ObjectStorageError {

    /// Key not exists error
    case keyNotExists
}

extension ObjectStorageError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .keyNotExists:
            return "Key not exists"
        }
    }
}
