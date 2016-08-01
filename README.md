# JSONRPCKit

JSONRPCKit is a [JSON-RPC 2.0](http://www.jsonrpc.org/specification) library purely written in Swift.

```swift
// Generating request JSON
let callBatchFactory = CallBatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
let request = SubtractRequest(lhs: 42, rhs: 23)
let batch = callBatchFactory.create(request)
batch.requestObject // ["jsonrpc": "2.0", "method": "subtract", "params": [42, 23], "id": 1]

// Parsing response JSON
let responseObject: AnyObject = ["jsonrpc": "2.0", "result": 19, "id": 1]
let response = try! batch.responsesFromObject(responseObject)
response // 19 (type of response is inferred from SubtractRequest.Response)
```

## Basic usage

1. Define request type
2. Generate request JSON
3. Parse response JSON

### Defining request type

First of all, define a request type that conforms to `RequestType`.

```swift
struct CountCharactersRequest: RequestType {
    typealias Response = CountCharactersResponse

    let characters: String

    var method: String {
        return "count_characters"
    }

    var parameters: AnyObject? {
        return ["characters": characters]
    }

    func responseFromResultObject(resultObject: AnyObject) throws -> Response {
        return try CountCharactersResponse(object: resultObject)
    }
}

struct CountCharactersResponse {
    let count: Int

    init(object: AnyObject) throws {
        enum DecodeError: ErrorType {
            case MissingValueForKey(String)
        }

        if let count = object["count"] as? Int {
            self.count = count
        } else {
            throw DecodeError.MissingValueForKey("count")
        }
    }
}
```


### Generating request JSON

To generate request JSON, pass `RequestType` instances to `CallBatchFactory` instance, which has common JSON-RPC version and identifier generator.
When `CallBatchFactory` instance receives request(s), it generates identifier(s) for the request(s) and request JSON by combining id, version, method and parameters.

```swift
let callBatchFactory = CallBatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
let request1 = CountCharactersRequest(characters: "tokyo")
let request2 = CountCharactersRequest(characters: "california")
let batch = callBatchFactory.create(request1, request2)
```

The request JSON is available in `batch.requestObject`. It looks like below:

```json
[
  {
    "jsonrpc" : "2.0",
    "method" : "count_characters",
    "id" : 1,
    "params" : {
      "characters" : "tokyo"
    }
  },
  {
    "jsonrpc" : "2.0",
    "method" : "count_characters",
    "id" : 2,
    "params" : {
      "characters" : "california"
    }
  }
]
```


### Parsing response JSON

Suppose that following JSON is returned from server:

```json
[
  {
    "jsonrpc" : "2.0",
    "id" : 1,
    "result" : {
      "count" : 5
    }
  },
  {
    "jsonrpc" : "2.0",
    "id" : 2,
    "result" : {
      "count" : 10
    }
  }
]
```

To parse response object, execute `responsesFromObject(_:)` of `CallBatchType` instance.
When `responsesFromObject(_:)` is called, `CallBatchType` finds corresponding response object by comparing request id and response id.
After it find the response object, it executes `responsesFromObject(_:)` of `Response` to get `Request.Response` from the response object.

```swift
let responseObject = ...
let (response1, response2) = try! batch.responsesFromObject(responseObject)
print(response1) // CountCharactersResponse(count: 5)
print(response2) // CountCharactersResponse(count: 10)
```

## JSON-RPC over HTTP by [APIKit](https://github.com/ishkawa/APIKit)

APIKit is a type-safe networking abstraction layer.

### Defining HTTP request type

APIKit also has `RequestType` that represents HTTP request.

```swift
import APIKit

struct MyServiceRequest<CallBatch: CallBatchType>: APIKit.RequestType {
    typealias Response = CallBatch.Responses

    let batch: CallBatch

    var baseURL: NSURL {
        return NSURL(string: "https://api.example.com/")!
    }

    var method: HTTPMethod {
        return .POST
    }

    var path: String {
        return "/"
    }

    var parameters: AnyObject? {
        return batch.requestObject
    }

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        return try batch.responsesFromObject(object)
    }
}
```

### Sending HTTP/HTTPS request

```swift
let callBatchFactory = CallBatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
let request1 = CountCharactersRequest(message: "tokyo")
let request2 = CountCharactersRequest(message: "california")
let batch = callBatchFactory.create(request1, request2)
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
