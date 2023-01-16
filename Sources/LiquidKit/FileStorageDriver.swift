//
//  FileStorageDriver.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation

///
/// Driver protocol
///
public protocol FileStorageDriver {

    /// Driver context
    var context: FileStorageDriverContext { get }

    ///
    /// Resolves a key to a fileURL string
    ///
    /// - Parameters:
    ///     - key: The unique key for the uploaded file
    ///
    /// - Returns:
    ///     The file URL as a String value
    ///
    func resolve(
        key: String
    ) -> String

    ///
    /// Uploads the data under the given key
    ///
    /// - Parameters:
    ///     - key: The unique key for the uploaded file
    ///     - data: The binary data representation of the file
    ///
    /// - Returns:
    ///     The file URL as a String value
    ///
    func upload(
        key: String,
        data: Data
    ) async throws -> String

    ///
    /// Check if a given key exists
    ///
    /// - Parameters:
    ///     - key: The unique key for the uploaded file
    ///
    /// - Returns:
    ///     A Bool value indicating the file's existence
    ///
    func exists(
        key: String
    ) async -> Bool

    ///
    /// Returns a file content for
    ///
    /// - Parameters:
    ///     - key: The unique key for the uploaded file
    ///
    /// - Throws: ·
    ///     An error if the key does not exists
    ///
    /// - Returns:
    ///     The binary data representation of the file
    ///
    func getObject(
        key source: String
    ) async throws -> Data?

    ///
    /// Copy a file using a source key to a given destination key
    ///
    func copy(
        key: String,
        to: String
    ) async throws -> String
    
    ///
    /// Move a file using a source key to a given destination key
    ///
    func move(
        key: String,
        to: String
    ) async throws -> String

    ///
    /// Create a new directory for a given key
    ///
    func createDirectory(
        key: String
    ) async throws
    
    ///
    /// List the contents of a given object for a key
    ///
    func list(
        key: String?
    ) async throws -> [String]
    
    ///
    /// Deletes the data under the given key
    ///
    func delete(
        key: String
    ) async throws
}
