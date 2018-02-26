import XCTest
@testable import core
//stubs

//mocks

//tests
class FunctionsTests: XCTestCase {
    func testStub() {
        let sum = testSUM(2, 3)
        let expected = 5
        XCTAssertEqual(sum, expected)
    }
}

extension FunctionsTests {
    static var allTests = [
            ("testStub", testStub)
    ]
}