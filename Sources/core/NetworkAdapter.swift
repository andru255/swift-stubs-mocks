import Foundation
import Dispatch

// typealiases
public typealias SuccessCallback = ((_ data: Data?) -> Void)?
public typealias FailCallback = ((_ errorMessage: String) -> Void)?
public enum RequestMethod {
    case GET
    case POST
}

public class NetworkAdapter {
    public init () {

    }
    func request(url: String, method: RequestMethod = .GET, success: SuccessCallback = nil, fail: FailCallback = nil){
        let url = URL(string: url)
        //config the request
        var request = URLRequest(url: url!)
        request.httpMethod = self.getMethodName(method: method)
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
                        if let failCallback = fail {
                            failCallback(error!.localizedDescription)
                        }
                        semaphore.signal()
                        return
                }
                if let httpStatus = response as? HTTPURLResponse,
                   httpStatus.statusCode == 200 {
                    if let successCallback = success {
                        successCallback(data)
                    }
                } else {
                    if let failCallback = fail {
                        failCallback(error!.localizedDescription)
                    }
                }
                semaphore.signal()
            }
        )
        task.resume()
        semaphore.wait()
    }

    private func getMethodName(method: RequestMethod) -> String {
        switch method {
            case .GET: return "GET"
            case .POST: return "POST"
        }
    }
}