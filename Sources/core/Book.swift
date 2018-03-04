import Foundation

// Protocols
protocol PocketProtocol {
    func readItLater(book: BookModel)
    func getAllToRead() -> [BookModel]
}
protocol BookFinderProtocol {
    func searchBy(author: String, success:((_ data:[BookModel?]) -> Void)?, fail: FailCallback)
}
// Models
public struct BookModel {
    public var id: String
    public var title: String
    public var author: [ String ]
}

// BookFinder
public class BookFinder: BookFinderProtocol {
    private var adapter: NetworkAdapter
    public init(adapter: NetworkAdapter){
        self.adapter = adapter
    }
    public func searchBy(author: String, success:((_ data:[BookModel?]) -> Void )? = nil, fail: FailCallback = nil) {
        var result: [BookModel?] = []
        let successResponse: SuccessCallback = { data in
            let json = try? JSONSerialization.jsonObject(with: data!, options:[])
            if let rootObject = json as? [String: Any],
               let docs =  rootObject["docs"] as! [[ String: Any? ]]? {
                   docs.forEach({ doc in
                       if let title = doc["title"] as? String,
                          let author = doc["author_name"] as? [ String ],
                          let id = doc["lending_identifier_s"] as? String {
                              let book = BookModel(id: id, title: title, author: author)
                              result.append(book)
                       }
                   })
                   if let successCallback = success {
                        successCallback(result)
                   }
            } else {
                fatalError("Formato del servicio no valido")
            }  
        }

        let failResponse: FailCallback = { error in
            if let failCallback = fail {
                failCallback(error)
            }
        }

        self.adapter.request(
            url: "http://openlibrary.org/search.json?author=\(author)", 
            success: successResponse, 
            fail: failResponse
        )
    }
}

// Repositories
public class Pocket: PocketProtocol {
    private var savedBooks: [BookModel] = []
    public init() {

    }
    public func readItLater(book: BookModel) {
        if !savedBooks.contains(where: { $0.id == book.id }) {
            savedBooks.append(book)
        }
    }
    public func getAllToRead() -> [BookModel] {
        return savedBooks
    }
}