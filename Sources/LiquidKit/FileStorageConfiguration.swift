//
//  FileStorageConfiguration.swift
//  LiquidKit
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

public protocol FileStorageConfiguration {

    func makeDriver(for: FileStorages) -> FileStorageDriver
}
