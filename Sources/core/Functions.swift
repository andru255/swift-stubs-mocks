import Foundation
import Dispatch

// typealiases
public typealias SuccessCallback = (_ data: Data?) -> Void
public typealias FailCallback = (_ error: Error) -> Void
public enum RequestMethod {
    case GET
    case POST
}

//protocol
protocol FunctionsProtocol {
    static func requestService(url: String, method: RequestMethod, success: @escaping(SuccessCallback), fail:@escaping(FailCallback))
    static func getMethodName(method: RequestMethod) -> String
}

public struct Functions: FunctionsProtocol {
    public static func requestService(url: String, method: RequestMethod = .GET, success: @escaping(SuccessCallback), fail:@escaping(FailCallback)){
        let url = URL(string: url)
        //config the request
        var request = URLRequest(url: url!)
        request.httpMethod = Functions.getMethodName(method: method)
        //config the session
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(
            configuration: sessionConfig,
            delegate: nil,
            delegateQueue: nil
        )
        let semaphore = DispatchSemaphore(value: 0)
        let task = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) -> Void in
                guard  let data = data,
                    error == nil else {
                        fail(error!)
                        exit(1)
                }
                if let httpStatus = response as? HTTPURLResponse,
                   httpStatus.statusCode == 200 {
                    success(data)
                } else {
                    fail(error!)
                }
                semaphore.signal()
            }
        )
        task.resume()
        semaphore.wait()
    }

    public static func getMethodName(method: RequestMethod) -> String {
        switch method {
            case .GET: return "GET"
            case .POST: return "POST"
        }
    }
}

// For testing
public struct MockFunctions: FunctionsProtocol {
    public static func requestService(url: String, method: RequestMethod = .GET, success: @escaping(SuccessCallback), fail:@escaping(FailCallback)){
        let path = "Sources/data/response.json"
        let fileManager = FileManager()
        if let content = fileManager.contents(atPath: path) {
            success(content)
        }
    }

    public static func getMethodName(method: RequestMethod) -> String {
        return "GET"
    }
}