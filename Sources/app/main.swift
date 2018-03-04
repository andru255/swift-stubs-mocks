import Foundation
import Glibc
import core

print("using the BookFinder to Search...")

let saveToRead = [
    "treeleaf00tolk",
    "lordofrings56tolk",
    "silmarillion00tolk"
]
let adapter = NetworkAdapter()
let bookFinder = BookFinder(adapter: adapter)
let pocket = Pocket()

bookFinder.searchBy(author: "tolkien", success: { booksFound in
    // saving the books:
    booksFound.forEach({ book in
        let isToRead = saveToRead.filter({ $0 == book!.id })
        if !isToRead.isEmpty {
            pocket.readItLater(book: book!)
        }
    })
    // print the favorites:
    let booksToRead = pocket.getAllToRead()
    booksToRead.forEach({ book in
        print("read it later --> ", book)
    })
}, fail: { error in 
    print("error found: \(error)")
})