//
//  FileStorageDriver.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

public protocol FileStorageDriver {
    func makeStorage(with context: FileStorageContext) -> FileStorage
    func shutdown()
}
