//
//  MockFileStorageDriverConfiguration.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation
import LiquidKit

struct MockFileStorageDriverConfiguration: FileStorageDriverConfiguration {
    
    func makeDriverFactory(
        using: FileStorageDriverFactoryStorage
    ) -> FileStorageDriverFactory {
        MockFileStorageDriverFactory()
    }
}

