//
//  Multipart.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2023. 02. 02..
//

public enum MultipartUpload {

    public struct ID: Hashable, Codable {
        
        public let value: String

        public init(_ value: String) {
            self.value = value
        }
    }

    public struct Chunk {
        public let id: String
        public let number: Int
        
        public init(
            id: String,
            number: Int
        ) {
            self.id = id
            self.number = number
        }
    }
}
