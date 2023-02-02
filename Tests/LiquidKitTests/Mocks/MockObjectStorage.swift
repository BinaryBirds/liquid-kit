//
//  MockObjectStorage.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import NIO
import LiquidKit

final class MockObjectStorage: ObjectStorage {

    var context: ObjectStorageContext
    var callStack: [String]
    
    init(
        context: ObjectStorageContext
    ) {
        self.context = context
        self.callStack = []
    }
    
    // MARK: - api
    
    func createChecksumCalculator() -> ChecksumCalculator {
        MockChecksumCalculator()
    }
    
    func upload(
        key: String,
        buffer: NIOCore.ByteBuffer,
        checksum: String?
    ) async throws {
        callStack.append(#function)
    }
    
    func copy(key: String, to: String) async throws {
        callStack.append(#function)
    }
    
    func move(key: String, to: String) async throws {
        callStack.append(#function)
    }
    
    func create(key: String) async throws {
        callStack.append(#function)
    }
    
    func createMultipartUpload(
        key: String
    ) async throws -> MultipartUpload.ID {
        callStack.append(#function)
        return .init("")
    }
    
    func uploadMultipartChunk(
        key: String,
        buffer: ByteBuffer,
        uploadId: MultipartUpload.ID,
        partNumber: Int
    ) async throws -> MultipartUpload.Chunk {
        callStack.append(#function)
        return .init(id: "", number: 1)
    }
    
    func cancelMultipartUpload(
        key: String,
        uploadId: MultipartUpload.ID
    ) async throws {
        callStack.append(#function)
    }
    
    func completeMultipartUpload(
        key: String,
        uploadId: MultipartUpload.ID,
        checksum: String?,
        chunks: [MultipartUpload.Chunk]
    ) async throws {
        callStack.append(#function)
    }
    
    func resolve(
        key: String
    ) -> String {
        callStack.append(#function)
        return key
    }
    
    func exists(key: String) async -> Bool {
        callStack.append(#function)
        return true
    }
    
    func download(
        key: String,
        range: ClosedRange<UInt>?
    ) async throws -> ByteBuffer {
        callStack.append(#function)
        return .init()
    }
    
    func copy(key: String, to: String) async throws -> String {
        callStack.append(#function)
        return to
    }
    
    func move(key: String, to: String) async throws -> String {
        callStack.append(#function)
        return to
    }
    
    func createDirectory(key: String) async throws {
        callStack.append(#function)
    }
    
    func list(key: String?) async throws -> [String] {
        callStack.append(#function)
        return [key ?? "root"]
    }
    
    func delete(key: String) async throws {
        callStack.append(#function)
    }
    
}
