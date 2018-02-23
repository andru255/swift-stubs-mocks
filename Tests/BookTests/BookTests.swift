import XCTest
@testable import Book
//stubs

//mocks

//tests
class BookTests: XCTestCase {
    func testStub() {
        XCTAssertEqual(1, 1)
    }
}

extension BookTests {
    static var allTests = [
            ("BookTestInit", testInit)
    ]
}