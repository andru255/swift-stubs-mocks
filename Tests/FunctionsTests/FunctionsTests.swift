import XCTest
import Quick
import MockSix
import Nimble
import NimbleMockSix

@testable import core

class FunctionsTests: QuickSpec {
    override func spec() {
        it("Functions.getMethodName->GET") {
            let methodName = Functions.getMethodName(method: .GET)
            expect("GET").to(equal(methodName))
        }
        it("Functions.getMethodName->POST") {
            let methodName = Functions.getMethodName(method: .POST)
            expect("POST").to(equal(methodName))
        }
    }
}