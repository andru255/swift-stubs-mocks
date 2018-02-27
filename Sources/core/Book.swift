import Foundation

// Protocols
protocol BookRepositoryProtocol {
    func markAsFavorite(book: BookEntity)
    func getFavorites() -> [BookEntity]
}
protocol BookServiceProtocol {
    func searchBy(author: String, success:@escaping((_ data:[BookEntity?]) -> Void ))
}
protocol BookEntityProtocol {
    var id: String {get set}
    var title: String {get set}
    var author: [String] {get set}
}

// Entities
public struct BookEntity: BookEntityProtocol {
    public var id: String
    public var title: String
    public var author: [ String ]
}

// Services
public class BookService: BookServiceProtocol {
    public init(){

    }
    public func searchBy(author: String, success:@escaping((_ data:[BookEntity?]) -> Void )) {
        var result: [BookEntity?] = []
        let successResponse: SuccessCallback = { data in
            let json = try? JSONSerialization.jsonObject(with: data!, options:[])
            if let rootObject = json as? [String: Any],
               let docs =  rootObject["docs"] as! [[ String: Any? ]]? {
                   docs.forEach({ doc in
                       if let title = doc["title"] as? String,
                          let author = doc["author_name"] as? [ String ],
                          let id = doc["lending_identifier_s"] as? String {
                              let book = BookEntity(id: id, title: title, author: author)
                              result.append(book)
                       }
                   })
                   success(result)
            }
        }

        let failResponse: FailCallback = { error in
            print(error)
        }

        Functions.requestService(
            url: "http://openlibrary.org/search.json?author=\(author)", 
            success: successResponse, 
            fail: failResponse
        )
    }
}

// Repositories
public class BookRepository: BookRepositoryProtocol {
    private var savedBooks: [BookEntity] = []
    public init() {

    }
    public func markAsFavorite(book: BookEntity) {
        if !savedBooks.contains(where: { $0.id == book.id }) {
            savedBooks.append(book)
        }
    }
    public func getFavorites() -> [BookEntity] {
        return savedBooks
    }
}