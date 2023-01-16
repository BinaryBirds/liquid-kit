# LiquidKit

An abstract FileStorage solution, based on the SwiftNIO framework.

## Key-based file storage 

- The main concept of LiquidKit is somewhat similar how AWS S3 buckets work.
- You can use keys (relative path components) to store files using various drivers.
- Keys should be designed to work with all the supported drivers.
- Drivers should provide a resolution mechanism to return the absolute URL for a given key.

e.g. 

the key "test.txt" could be resolved to "http://localhost:8080/assets/test.txt" when using the local fs driver.


## Usage with SwiftNIO

You can use the Liquid FileStorage driver directly with SwiftNIO, here's a possible usage example:   

```swift
import NIO
import Logger
import LiquidKit

let logger = Logger(label: "test-logger")
let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
let pool = NIOThreadPool(numberOfThreads: 1)
let fileio = NonBlockingFileIO(threadPool: pool)
pool.start()

let driverFactoryStorage = FileStorageDriverFactoryStorage(
    eventLoopGroup: eventLoopGroup,
    fileio: fileio
)

driverFactoryStorage.use(.mock(), as: .mock)

let fs = driverFactoryStorage.makeDriver(
    logger: logger,
    on: eventLoopGroup.next()
)
```


## How to implement a custom driver?

Packages should follow these instructions to create a new driver.


### FileStorageDriverID extension

Create a unique identifier that represents your driver.

```swift
extension FileStorageDriverID {

    static let mock: FileStorageDriverID = .init(string: "mock")
}
```

### FileStorageDriver implementation

Actual driver implementation that should contain necessary API methods.

```swift
struct MockFileStorageDriver: FileStorageDriver {

    var context: FileStorageDriverContext
    var callStack: [String]
    
    init(
        context: FileStorageDriverContext
    ) {
        self.context = context
    }
    
    // IMPLEMENT ALL THE REQUIRED PROTOCOL METHODS

```

### FileStorageDriverFactory implementation

The factory that'll create the driver instances.

```swift
struct MockFileStorageDriverFactory: FileStorageDriverFactory {

    func makeDriver(
        using context: FileStorageDriverContext
    ) -> FileStorageDriver {
        MockFileStorageDriver(context: context)
    }
    
    func shutdown() {
        // do nothing...
    }
}
```

### FileStorageDriverConfiguration implementation

A custom driver configuration that you can use to create the driver factory. 

```swift
struct MockFileStorageDriverConfiguration: FileStorageDriverConfiguration {
    
    func makeDriverFactory(
        using: FileStorageDriverFactoryStorage
    ) -> FileStorageDriverFactory {
        MockFileStorageDriverFactory()
    }
}
```

### FileStorageConfigurationFactory extension

A helper to create the actual driver configuration using the wrapper factory.

```swift
extension FileStorageDriverConfigurationFactory {
    
    static func mock() -> FileStorageDriverConfigurationFactory {
        .init { MockFileStorageDriverConfiguration() }
    }
}
```

## Current driver implementations and Vapor 4 support

Currently available drivers:

- [local](https://github.com/BinaryBirds/liquid-local-driver)
- [AWS S3](https://github.com/BinaryBirds/liquid-aws-s3-driver)

LiquidKit is also compatible with Vapor 4 through the [Liquid](https://github.com/BinaryBirds/liquid) repository, that contains Vapor specific extensions.
