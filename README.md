# JSONRPCKit

JSONRPCKit is a [JSON-RPC 2.0](http://www.jsonrpc.org/specification) library purely written in Swift. This library is highly inspired by [APIKit](https://github.com/ishkawa/APIKit).


## Basic usage

### Defining request

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


### Creating request

To create JSON-RPC request object, pass `RequestType` instances to `CallFactory` instance.

```swift
let callFactory = CallFactory(version: "2.0", idGenerator: NumberIdGenerator())
let request1 = CountCharactersRequest(characters: "tokyo")
let request2 = CountCharactersRequest(characters: "sapporo")
let call = callFactory.create(request1, request2)
```

`CallFactory` creates `CallType` instance, which represents JSON-RPC call.
`call.requestObject` represents JSON-RPC request object.

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


### Parsing response

Suppose that following JSON is returned as response object:

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

To parse response object, execute `responseFromObject(_:)` of `CallFactory` instance.
This method returns tuple of responses.

```swift
let call = ...
let responseObject = ...
let (response1, response2) = try! call.responsesFromObject(responseObject)
print(response1) // CountCharactersResponse(count: 5)
print(response2) // CountCharactersResponse(count: 10)
```


### Handling errors individually

If you need to treat results of individually, use `resultsFromObject(_:)` of `CallFactory` instance.
In JSON below, the first response indicates success, but the second one indicates failure.

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
    "error" : {
      "code" : 999,
      "message" : "error!"
    }
  }
]
```

`resultsFromObject(_:)` returns tuple of `Result<Request.Response, JSONRPCError>`.

```swift
let call = ...
let responseObject = ...
let (result1, result2) = call.resultsFromObject(responseObject)
print(response1.count) // Result.Success(CountCharactersResponse(count: 5))
print(response2.count) // Result.Failure(JSONRPCError.ResponseError(code: 999, message: "error!", data: nil))
```

## Combination with APIKit

[APIKit](https://github.com/ishkawa/APIKit) is useful to implement JSON-RPC over HTTP/HTTPS.

### Defining RequestType in APIKit

```swift
import APIKit

struct MyServiceRequest<Call: CallType>: APIKit.RequestType {
    typealias Response = Call.Response

    let call: Call

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
        return call.requestObject
    }

    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        return try call.responsesFromObject(object)
    }
}
```

### Sending HTTP/HTTPS request

```swift
let callFactory = CallFactory(version: "2.0", idGenerator: NumberIdGenerator())
let request1 = CountCharactersRequest(message: "tokyo")
let request2 = CountCharactersRequest(message: "sapporo")
let call = callFactory.create(request1, request2)
let httpRequest = MyServiceRequest(call: call)

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
