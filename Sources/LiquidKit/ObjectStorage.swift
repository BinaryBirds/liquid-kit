//
//  ObjectStorage.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import NIO

///
/// Object storage protocol
///
public protocol ObjectStorage {

    /// Object storage context
    var context: ObjectStorageContext { get }

    /// Checksum calculator for upload validations
    func createChecksumCalculator() -> ChecksumCalculator

    ///
    /// Resolves a key to a fileURL string
    ///
    /// - Parameters:
    ///     - key: The unique key for the uploaded file
    ///
    /// - Returns:
    ///     The object URL as a String value
    ///
    func resolve(
        key: String
    ) -> String

    ///
    /// Uploads the data under the given key
    ///
    /// - Parameters:
    ///     - key: The unique key for the uploaded file
    ///     - buffer: The byte buffer representation of the object
    ///     - checksum: The checksum to validate object integrity
    ///
    func upload(
        key: String,
        buffer: ByteBuffer,
        checksum: String?
    ) async throws

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
    ///     The byte buffer representation of the file
    ///
    func download(
        key source: String,
        range: ClosedRange<UInt>?
    ) async throws -> ByteBuffer

    ///
    /// Copy a file using a source key to a given destination key
    ///
    func copy(
        key: String,
        to: String
    ) async throws
    
    ///
    /// Move a file using a source key to a given destination key
    ///
    func move(
        key: String,
        to: String
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
    
    
    func create(
        key: String
    ) async throws
    
    // MARK: - multipart upload
    
    func createMultipartUpload(
        key: String
    ) async throws -> MultipartUpload.ID
    
    
    func uploadMultipartChunk(
        key: String,
        buffer: ByteBuffer,
        uploadId: MultipartUpload.ID,
        partNumber: Int
    ) async throws -> MultipartUpload.Chunk

    
    func cancelMultipartUpload(
        key: String,
        uploadId: MultipartUpload.ID
    ) async throws

    
    func completeMultipartUpload(
        key: String,
        uploadId: MultipartUpload.ID,
        checksum: String?,
        chunks: [MultipartUpload.Chunk]
    ) async throws
}
