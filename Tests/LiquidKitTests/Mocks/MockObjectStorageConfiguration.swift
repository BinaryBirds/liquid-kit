//
//  MockObjectStorageConfiguration.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation
import LiquidKit

struct MockObjectStorageConfiguration: ObjectStorageConfiguration {
    
    func makeDriverFactory(
        using: ObjectStorages
    ) -> ObjectStorageDriver {
        MockObjectStorageDriver()
    }
}

