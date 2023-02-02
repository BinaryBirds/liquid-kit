//
//  ObjectStorageConfigurationFactory+Mock.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import LiquidKit

extension ObjectStorageConfigurationFactory {
    
    static func mock() -> ObjectStorageConfigurationFactory {
        .init { MockObjectStorageConfiguration() }
    }

}
