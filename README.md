# JSONRPCKit

[![Build Status](https://travis-ci.org/bricklife/JSONRPCKit.svg?branch=master)](https://travis-ci.org/bricklife/JSONRPCKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/JSONRPCKit.svg)](https://cocoapods.org/)

JSONRPCKit is a [JSON-RPC 2.0](http://www.jsonrpc.org/specification) library purely written in Swift.

```swift
// Generating request JSON
let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
let request = Subtract(minuend: 42, subtrahend: 23)
let batch = batchFactory.create(request)
batch.requestObject // ["jsonrpc": "2.0", "method": "subtract", "params": [42, 23], "id": 1]

// Parsing response JSON
let responseObject: Any = ["jsonrpc": "2.0", "result": 19, "id": 1]
let response = try! batch.responses(from: responseObject)
response // 19 (type of response is inferred from SubtractRequest.Response)
```


## Requirements

- Swift 4.0 or later
- iOS 8.0 or later
- macOS 10.9 or later
- watchOS 2.0 or later
- tvOS 9.0 or later

## Basic usage

1. Define request type
2. Generate request JSON
3. Parse response JSON

### Defining request type

First of all, define a request type that conforms to `Request`.

```swift
struct Subtract: JSONRPCKit.Request {
    typealias Response = Int

    let minuend: Int
    let subtrahend: Int

    var method: String {
        return "subtract"
    }

    var parameters: Any? {
        return [minuend, subtrahend]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
```


### Generating request JSON

To generate request JSON, pass `Request` instances to `BatchFactory` instance, which has common JSON-RPC version and identifier generator.
When `BatchFactory` instance receives request(s), it generates identifier(s) for the request(s) and request JSON by combining id, version, method and parameters.

```swift
let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
let request1 = Subtract(minuend: 42, subtrahend: 23)
let request2 = Subtract(minuend: 23, subtrahend: 42)
let batch = batchFactory.create(request1, request2)
```

The request JSON is available in `batch.requestObject`. It looks like below:

```json
[
  {
    "method" : "subtract",
    "jsonrpc" : "2.0",
    "id" : 1,
    "params" : [
      42,
      23
    ]
  },
  {
    "method" : "subtract",
    "jsonrpc" : "2.0",
    "id" : 2,
    "params" : [
      23,
      42
    ]
  }
]
```


### Parsing response JSON

Suppose that following JSON is returned from server:

```json
[
  {
    "result" : 19,
    "jsonrpc" : "2.0",
    "id" : 1,
    "status" : 0
  },
  {
    "result" : -19,
    "jsonrpc" : "2.0",
    "id" : 2,
    "status" : 0
  }
]
```

To parse response object, execute `responses(from:)` of `Batch` instance.
When `responses(from:)` is called, `Batch` finds corresponding response object by comparing request id and response id.
After it find the response object, it executes `responses(from:)` of `Response` to get `Request.Response` from the response object.

```swift
let responseObject = ...
let (response1, response2) = try! batch.responses(from: responseObject)
print(response1) // 19
print(response2) // -19
```

## JSON-RPC over HTTP by [APIKit](https://github.com/ishkawa/APIKit)

APIKit is a type-safe networking abstraction layer.

### Defining HTTP request type

APIKit also has `RequestType` that represents HTTP request.

```swift
import APIKit

struct MyServiceRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    let batch: Batch

    typealias Response = Batch.Responses

    var baseURL: URL {
        return NSURL(string: "https://api.example.com/")!
    }

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        return "/"
    }

    var parameters: Any? {
        return batch.requestObject
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try batch.responses(from: object)
    }
}
```

### Sending HTTP/HTTPS request

```swift
let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
let request1 = Subtract(minuend: 42, subtrahend: 23)
let request2 = Subtract(minuend: 23, subtrahend: 42)
let batch = batchFactory.create(request1, request2)
let httpRequest = MyServiceRequest(batch: batch)

Session.sendRequest(httpRequest) { result in
    switch result {
    case .Success(let response1, let response2):
        print(response1.count) // CountCharactersResponse
        print(response2.count) // CountCharactersResponse

    case .Failure(let error):
        print(error)
    }
}
```

## License

JSONRPCKit is released under the [MIT License](LICENSE.md).
