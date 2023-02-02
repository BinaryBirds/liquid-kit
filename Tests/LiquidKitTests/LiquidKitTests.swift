//
//  LiquidKitTests.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import XCTest
import Foundation
import NIO
import NIOFoundationCompat
import Logging
@testable import LiquidKit

final class LiquidKitTests: XCTestCase {

    func createMockDriver() -> MockObjectStorage {
        let logger = Logger(label: "test-logger")
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let pool = NIOThreadPool(numberOfThreads: 1)
        let fileio = NonBlockingFileIO(threadPool: pool)
        pool.start()

        let objectStorages = ObjectStorages(
            eventLoopGroup: eventLoopGroup,
            byteBufferAllocator: .init(),
            fileio: fileio
        )

        objectStorages.use(.mock(), as: .mock)

        return objectStorages.make(
            logger: logger,
            on: eventLoopGroup.next()
        )! as! MockObjectStorage
    }

    func testMockDriverUpload() async throws {
        let fs = createMockDriver()

        let key = "test.txt"
        let data = Data("file storage test".utf8)
        _ = try await fs.upload(
            key: key,
            buffer: .init(data: data),
            checksum: nil
        )
    
        XCTAssertEqual(fs.callStack, ["upload(key:buffer:checksum:)"])
    }
}
