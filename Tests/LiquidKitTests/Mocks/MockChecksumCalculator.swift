//
//  MockChecksumCalculator.swift
//  LiquicKitTests
//
//  Created by Tibor Bodecs on 2023. 02. 02..
//

import LiquidKit

final class MockChecksumCalculator: ChecksumCalculator {
    
    func update(_: [UInt8]) {
        
    }
    
    func finalize() -> String {
        ""
    }
}
