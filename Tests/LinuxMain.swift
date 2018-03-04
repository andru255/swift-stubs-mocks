import XCTest
import Quick

@testable import NetworkAdapterTests
@testable import BooksTests

print("starting tests...")
Quick.QCKMain([
    NetworkAdapterTests.self,
    BooksTests.self
])