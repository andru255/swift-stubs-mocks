import Foundation
import Dispatch

// typealiases
public typealias SuccessCallback = (_ data: Data?) -> Void
public typealias FailCallback = (_ error: Error) -> Void

//
public func requestService(url: String, method: String = "GET", success: @escaping(SuccessCallback), fail:@escaping(FailCallback)){
    //let url = URL(string: "http://openlibrary.org/search.json?author=tolkien")
    let url = URL(string: url)
    //config the request
    var request = URLRequest(url: url!)
    request.httpMethod = method
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

public func stubRequestService(url: String, method: String = "GET", success: @escaping(SuccessCallback), fail:@escaping(FailCallback)) {
    let path = "Sources/data/response.json"
    let fileManager = FileManager()
    if let content = fileManager.contents(atPath: path) {
        success(content)
    }
}

public func testSUM(_ a: Int,_ b: Int) -> Int {
    return a + b
}