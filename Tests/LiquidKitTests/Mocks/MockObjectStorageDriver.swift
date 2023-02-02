//
//  MockObjectStorageDriver.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import LiquidKit

struct MockObjectStorageDriver: ObjectStorageDriver {

    func make(
        using context: ObjectStorageContext
    ) -> ObjectStorage {
        MockObjectStorage(context: context)
    }
    
    func shutdown() {
        // do nothing...
    }
}

