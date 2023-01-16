//
//  LiquidKitTests.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import XCTest
import NIO
import Logging
@testable import LiquidKit

final class LiquidKitTests: XCTestCase {

    func createMockDriver() -> MockFileStorageDriver {
        let logger = Logger(label: "test-logger")
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let pool = NIOThreadPool(numberOfThreads: 1)
        let fileio = NonBlockingFileIO(threadPool: pool)
        pool.start()

        let driverFactoryStorage = FileStorageDriverFactoryStorage(
            eventLoopGroup: eventLoopGroup,
            byteBufferAllocator: .init(),
            fileio: fileio
        )

        driverFactoryStorage.use(.mock(), as: .mock)

        return driverFactoryStorage.makeDriver(
            logger: logger,
            on: eventLoopGroup.next()
        )! as! MockFileStorageDriver
    }

    func testMockDriverUpload() async throws {
        let fs = createMockDriver()

        let key = "test.txt"
        let data = Data("file storage test".utf8)
        _ = try await fs.upload(key: key, data: data)
        XCTAssertEqual(fs.callStack, ["upload(key:data:)"])
    }
}
