//
//  FileStorage.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import struct Foundation.Data

public protocol FileStorage {
    var context: FileStorageContext { get }

    /// returns a key as a full url
    func resolve(key: String) -> String

    /// uploads the data under the given key
    func upload(key: String, data: Data) -> EventLoopFuture<String>

    /// copy a file using a source key to a given destination key
    func copy(key: String, to: String) -> EventLoopFuture<String>
    
    /// move a file using a source key to a given destination key
    func move(key: String, to: String) -> EventLoopFuture<String>

    /// create a new directory for a given key
    func createDirectory(key: String) -> EventLoopFuture<Void>
    
    /// list the contents of a given object for a key
    func list(key: String?) -> EventLoopFuture<[String]>
    
    /// deletes the data under the given key
    func delete(key: String) -> EventLoopFuture<Void>
    
    /// check if a given key exists
    func exists(key: String) -> EventLoopFuture<Bool>
}
