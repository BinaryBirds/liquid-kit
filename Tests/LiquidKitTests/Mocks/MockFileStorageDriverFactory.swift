//
//  MockFileStorageDriverFactory.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation
import LiquidKit

struct MockFileStorageDriverFactory: FileStorageDriverFactory {

    func makeDriver(
        using context: FileStorageDriverContext
    ) -> FileStorageDriver {
        MockFileStorageDriver(context: context)
    }
    
    func shutdown() {
        // do nothing...
    }
}

