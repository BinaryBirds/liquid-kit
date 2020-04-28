//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation
import NIO

public protocol FileStorage {
    var context: FileStorageContext { get }

    //returns a key as a full url
    func resolve(key: String) -> String
    
    // uploads the data under the given key
    func upload(key: String, data: Data) -> EventLoopFuture<String>
    
    // deletes the data under the given key
    func delete(key: String) -> EventLoopFuture<Void>
}
