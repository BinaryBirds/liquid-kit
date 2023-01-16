//
//  FileStorageDriverConfigurationFactory+Mock.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation
import LiquidKit

extension FileStorageDriverConfigurationFactory {
    
    static func mock() -> FileStorageDriverConfigurationFactory {
        .init { MockFileStorageDriverConfiguration() }
    }

}
