//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 04. 28..
//

import Foundation

public protocol FileStorageConfiguration {

    func makeDriver(for: FileStorages) -> FileStorageDriver
}
