import XCTest
import Quick
import Nimble

@testable import core

// For testing
// Stubs
extension NetworkAdapter {
    public func requestServiceSuccess(url: String, method: RequestMethod = .GET, success: SuccessCallback = nil, fail: FailCallback = nil){
        let path = "Sources/data/response.json"
        let fileManager = FileManager()
        if let content = fileManager.contents(atPath: path),
           let successCallback = success {
            successCallback(content)
        }
    }
    public func requestServiceFail(url: String, method: RequestMethod = .GET, success: SuccessCallback = nil, fail: FailCallback = nil ) {
        if let failCallback = fail {
            failCallback("error found")
        }
    }
}

// Mocking BookFinder
class MockBookFinder: BookFinderProtocol {
    private var adapter: NetworkAdapter
    private var totalSearch: Int

    public init(adapter: NetworkAdapter){
        self.adapter = adapter
        self.totalSearch = 0
    }
    public func searchBy(author: String, success:((_ data:[BookModel?]) -> Void )? = nil, fail: FailCallback = nil) {
        let dataFake:[BookModel] = [
            BookModel(id: "a", title: "five cities", author: [ "jhon doe" ])
        ]
        self.adapter.requestServiceSuccess(
            url: "fake",
            success: { _ in 
                if let successCallback = success {
                    successCallback(dataFake)
                }
            } 
        )
        totalSearch += 1
    }
    public func searchByFail(author: String, success:((_ data:[BookModel?]) -> Void )? = nil, fail:FailCallback = nil){
        self.adapter.requestServiceFail(
            url: "fake", 
            fail: fail
        )
        totalSearch += 1
    }
    public func getTotalSearch() -> Int {
        return self.totalSearch
    }
}

class BooksTests: QuickSpec {
    override func spec() {
        describe("Book") {
            let adapter = NetworkAdapter()
            let mockFinder = MockBookFinder(adapter: adapter)

            it("MockBookFinder.searchBy success") {
                var wasSuccess = false
                mockFinder.searchBy(author: "jhon doe", success: { data in
                    wasSuccess = true
                })
                expect(wasSuccess).toEventually(equal(true))
            }

            it("MockBookFinder.searchBy error") {
                var wasFail = false
                mockFinder.searchByFail(author: "jhon doe", fail: { _ in 
                    wasFail = true
                })
                expect(wasFail).toEventually(equal(true))
            }

            it("MockBookFinder.getTotalSearch") {
                expect(mockFinder.getTotalSearch()).to(equal(2))
            }
        }
    }
}