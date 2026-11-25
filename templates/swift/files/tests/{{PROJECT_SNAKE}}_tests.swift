// XCTest ships with the toolchain, so there is nothing in Package.swift for it.
import XCTest

// `@testable` raises the visibility the test sees: internal declarations become
// reachable, which they would not be from an ordinary import. The backticks quote
// the module name, because a project may be named after a Swift keyword and this
// is the escape that keeps that project building.
@testable import `{{PROJECT_SNAKE}}`

// XCTest on purpose, where the kitchen sink is swift-testing: `swift test` exits
// 2 on a test target with nothing in it, so this file is what keeps deleting the
// kitchen sink safe. Both libraries ship, and one `swift test` runs both.
//
// Nothing names this file. XCTest discovers by subclassing -- any `final class`
// extending XCTestCase, with methods whose names begin with `test` -- so a test
// is found by being shaped like one. That is also why the name here is camel
// case: discovery is the method identifier, and there is no string to put a
// sentence in. The kitchen sink uses swift-testing instead, where `@Test("...")`
// takes one.
final class GreetingTests: XCTestCase {
  func testAGreetingAddressesTheNameItIsGiven() {
    // Arrange, act, assert, separated by blank lines. `let` is a constant and
    // `var` a variable; reach for `let` until the compiler objects.
    let name = "world"

    let greeting = greet(name)

    // Actual first, expected second. Swapping them still passes and only makes
    // the failure message name the wrong side as the problem.
    XCTAssertEqual(greeting, "Hello, world!")
  }
}
