import XCTest
@testable import BookTests

print("starting tests...")
XCTMain([
    testCase(BookTests.allTests)
])