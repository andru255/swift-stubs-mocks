import Foundation
import Dispatch

//Academic functions
//let headers = []
//let parameters = []
func success(data: Data) {
    let json = try? JSONSerialization.jsonObject(with: data, options: [])
    print(type(of: json))
}

let url = URL(string: "http://openlibrary.org/search.json?author=tolkien")
var request = URLRequest(url: url!)
request.httpMethod = "GET"
let sessionConfig = URLSessionConfiguration.default
let session = URLSession(
    configuration: sessionConfig,
    delegate: nil,
    delegateQueue: nil
)
let semaphore = DispatchSemaphore(value: 0)
let dataTask = session.dataTask(
    with: request as URLRequest, 
    completionHandler: { (data, response, error) -> Void in
        guard let data = data,
              error == nil else {
                  print("error :(!!")
                  exit(1)
              }
        if let httpStatus = response as? HTTPURLResponse {
            if httpStatus.statusCode == 200 {
                success(data: data)
                exit(0)
            } else {
                print("unexpected response: \(httpStatus.statusCode)!!")
            }
        }
        print("operation concluded")
        semaphore.signal()
})
dataTask.resume()
semaphore.wait()
print("Wait the example...")