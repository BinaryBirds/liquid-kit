//
//  MockObjectStorageConfiguration.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import LiquidKit

struct MockObjectStorageConfiguration: ObjectStorageConfiguration {
    
    func make(
        using: ObjectStorages
    ) -> ObjectStorageDriver {
        MockObjectStorageDriver()
    }
}
