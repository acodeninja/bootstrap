import XCTest

@testable import `{{PROJECT_SNAKE}}`

// XCTest on purpose, where the kitchen sink is swift-testing: `swift test`
// exits 2 on a test target with nothing in it, so this file is what keeps
// deleting the kitchen sink safe.
final class GreetingTests: XCTestCase {
  func testAGreetingAddressesTheNameItIsGiven() {
    let name = "world"

    let greeting = greet(name)

    XCTAssertEqual(greeting, "Hello, world!")
  }
}
