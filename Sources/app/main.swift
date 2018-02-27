import Foundation
import core

print("using the book service to Search...")

let myFavorites = [
    "treeleaf00tolk",
    "lordofrings56tolk",
    "silmarillion00tolk"
]
let bookService = BookService()
let bookRepository = BookRepository()

bookService.searchBy(author: "tolkien", success: { data in
    // saving the books:
    data.forEach({ book in
        let isFavorite = myFavorites.filter({ $0 == book!.id })
        if !isFavorite.isEmpty {
            bookRepository.markAsFavorite(book: book!)
        }
    })
    // print the favorites:
    let favorites = bookRepository.getFavorites()
    favorites.forEach({ favorite in
        print("my favorites --> ", favorite)
    })
})