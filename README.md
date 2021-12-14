# LiquidKit

An abstract FileStorage solution, based on the SwiftNIO framework.


## Key-based file storage 

- The main concept of LiquidKit is somewhat similar how AWS S3 buckets work.
- You can use keys (relative path components) to store files using various drivers.
- Keys should be designed to work with all the supported drivers.
- Drivers should provide a resolution mechanism to return the absolute URL for a given key.

e.g. 

the key "test.txt" could be resolved to "http://localhost:8080/assets/test.txt" when using the local fs driver.


## Drivers and Vapor 4 support

Currently available drivers:

- [local](https://github.com/BinaryBirds/liquid-local-driver)
- [AWS S3](https://github.com/BinaryBirds/liquid-aws-s3-driver)

LiquidKit is also compatible with Vapor 4 through the [Liquid](https://github.com/BinaryBirds/liquid) repository, that contains Vapor specific extensions.


## Usage with SwiftNIO

You can use the Liquid FileStorage driver directly with SwiftNIO, here's a possible usage example:   

```
/// setup thread pool
let elg = MultiThreadedEventLoopGroup(numberOfThreads: 1)
let pool = NIOThreadPool(numberOfThreads: 1)
pool.start()

/// create fs  
let fileio = NonBlockingFileIO(threadPool: pool)
let storages = FileStorages(fileio: fileio)
storages.use(.custom(exampleConfigVariable: "assets"), as: .custom)
let fs = storages.fileStorage(.custom, logger: .init(label: "[test-logger]"), on: elg.next())!

/// test file upload
let key = "test.txt"
let data = Data("file storage test".utf8)
let res = try fs.upload(key: key, data: data).wait()

```


## How to implement a custom driver?

Drivers should implement the following protocols:


### FileStorageID

Used to uniquely identify the file storage driver.

```swift
public extension FileStorageID {
    static var customDriver: FileStorageID { .init(string: "custom-driver-identifier") }
}
```

### FileStorageConfiguration

A custom set of configuration variables required to initialize or setup the driver. 

```swift
struct LiquidCustomStorageConfiguration: FileStorageConfiguration {
    let exampleConfigVariable: String

    func makeDriver(for storages: FileStorages) -> FileStorageDriver {
        return LiquidCustomStorageDriver(fileio: storages.fileio, configuration: self)
    }
}
```

### FileStorageDriver

The file storage driver used to create the underlying storage object (that implements the API methods) using the configuration and context.

```swift
struct LiquidCustomStorageDriver: FileStorageDriver {

    let fileio: NonBlockingFileIO
    let configuration: LiquidCustomStorageConfiguration

    func makeStorage(with context: FileStorageContext) -> FileStorage {
        LiquidCustomStorage(fileio: fileio, configuration: configuration, context: context)
    }
    
    func shutdown() {

    }
}
```

### FileStorage

Actual storage implementation that handles the necessary API methods.

```swift

struct LiquidCustomStorage: FileStorage {

    let fileio: NonBlockingFileIO
    let configuration: LiquidCustomStorageConfiguration
    let context: FileStorageContext
    
    
    init(fileio: NonBlockingFileIO, configuration: LiquidCustomStorageConfiguration, context: FileStorageContext) {
        self.fileio = fileio
        self.configuration = configuration
        self.context = context
    }

    // MARK: - api

    func resolve(key: String) -> String { /* ... */ }
    func upload(key: String, data: Data) async throws -> String { /* ... */ }
    func createDirectory(key: String) async throws { /* ... */ }
    func list(key: String?) async throws -> [String] { /* ... */ }
    func copy(key source: String, to destination: String) async throws -> String { /* ... */ }
    func move(key source: String, to destination: String) async throws -> String { /* ... */ }
    func delete(key: String) async throws { /* ... */ }
    func exists(key: String) async -> Bool { /* ... */ }
}
```

### FileStorageConfigurationFactory

An extension on the FileStorageConfigurationFactory object that helps you to create the custom driver with the necessary config values.

```swift
public extension FileStorageConfigurationFactory {

    static func custom(exampleConfigVariable: String) -> FileStorageConfigurationFactory {
        .init { LiquidCustomStorageConfiguration(exampleConfigVariable) }
    }
}
```

