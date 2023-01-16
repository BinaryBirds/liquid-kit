//
//  MockFileStorageDriver.swift
//  LiquidKitTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import Foundation
import LiquidKit

final class MockFileStorageDriver: FileStorageDriver {

    var context: FileStorageDriverContext
    var callStack: [String]
    
    init(
        context: FileStorageDriverContext
    ) {
        self.context = context
        self.callStack = []
    }
    
    func resolve(key: String) -> String {
        callStack.append(#function)
        return key
    }
    
    func upload(key: String, data: Data) async throws -> String {
        callStack.append(#function)
        return key
    }
    
    func exists(key: String) async -> Bool {
        callStack.append(#function)
        return true
    }
    
    func getObject(key source: String) async throws -> Data? {
        callStack.append(#function)
        return nil
    }
    
    func copy(key: String, to: String) async throws -> String {
        callStack.append(#function)
        return to
    }
    
    func move(key: String, to: String) async throws -> String {
        callStack.append(#function)
        return to
    }
    
    func createDirectory(key: String) async throws {
        callStack.append(#function)
    }
    
    func list(key: String?) async throws -> [String] {
        callStack.append(#function)
        return [key ?? "root"]
    }
    
    func delete(key: String) async throws {
        callStack.append(#function)
    }
    
}
