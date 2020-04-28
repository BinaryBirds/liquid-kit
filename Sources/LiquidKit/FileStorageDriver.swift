//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation

public protocol FileStorageDriver {
    func makeStorage(with context: FileStorageContext) -> FileStorage
    func shutdown()
}
