//
//  ChecksumCalculator.swift
//  Liquid-Kit
//
//  Created by Tibor Bodecs on 2023. 02. 02..
//

public protocol ChecksumCalculator {
    func update(_: [UInt8])
    func finalize() -> String
}
