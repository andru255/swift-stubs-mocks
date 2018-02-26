import Foundation
import core

let successResponse: SuccessCallback = { data in
    let json = try? JSONSerialization.jsonObject(with: data!, options:[])
    if let rootObject = json as? [String: Any],
       let docs =  rootObject["docs"] as! [[ String: Any? ]]? {
           docs.forEach({ doc in
               if let title = doc["title"] as? String {
                   print("title: \(title)")
               }
           })
    }
}

let failResponse: FailCallback = { error in
    print(error)
}

print("making a single request...")
//requestService(
//    url: "http://openlibrary.org/search.json?author=tolkien", 
//    success:successResponse, 
//    fail: failResponse
//)

stubRequestService(
    url: "http://openlibrary.org/search.json?author=tolkien", 
    success:successResponse, 
    fail: failResponse
)