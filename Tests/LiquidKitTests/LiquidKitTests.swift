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
        let os = createMockDriver()
        let contents = "file storage test"
        let key = "test.txt"
        
        try await os.upload(
            key: key,
            buffer: .init(string: contents),
            checksum: nil,
            timeout: .seconds(30)
        )
    
        XCTAssertEqual(os.callStack, [
            "upload(key:buffer:checksum:timeout:)"
        ])
    }
}
