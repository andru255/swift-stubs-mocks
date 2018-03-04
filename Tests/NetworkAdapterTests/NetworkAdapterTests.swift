import XCTest
import Quick
import Nimble

@testable import core

class NetworkAdapterTests: QuickSpec {
    override func spec() {
        describe("NetworkAdapter") {
            let adapter = NetworkAdapter()

            it("requestService:success") {
                var successWasCalled = false
                adapter.request(
                    url: "http://google.com",
                    method: .GET,
                    success: { _ in successWasCalled = true },
                    fail: { _ in })
                expect(true).toEventually(equal(successWasCalled))
            }

            it("requestService:fail") {
                var failWasCalled = false
                adapter.request(
                    url: "http://out.localhost",
                    method: .GET,
                    success: { _ in },
                    fail: { _ in failWasCalled = true })
                expect(true).toEventually(equal(failWasCalled))
            }

        }
    }
}