//
//  FileStorageID.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

public struct FileStorageID: Hashable, Codable {
    public let string: String
    public init(string: String) {
        self.string = string
    }
}
