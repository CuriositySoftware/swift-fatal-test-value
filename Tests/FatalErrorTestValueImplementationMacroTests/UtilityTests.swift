import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
import _SwiftSyntaxTestSupport
@testable import FatalErrorTestValueImplementationMacro

final class UtilityTests: XCTestCase {
    func testParameterClauseReturnsEmptyStringForClosureWithoutArguments() throws {
        try XCTContext.runActivity(named: "no argument") { _ in
            let functionType = try VariableDeclSyntax("var foo: () -> ()") {}
                .bindings.first!.closure!

            let parameterClause = parameterClause(functionType)

            assertStringsEqualWithDiff(
                parameterClause.formatted().description,
                """
                """
            )
        }
    }

    func testParameterClauseReturnsWildcard() throws {
        try XCTContext.runActivity(named: "one argument") { _ in
            let functionType = try VariableDeclSyntax("var foo: (Int) -> ()") {}
                .bindings.first!.closure!

            let parameterClause = parameterClause(functionType)

            assertStringsEqualWithDiff(
                parameterClause.formatted().description,
                """
                _
                """
            )
        }

        try XCTContext.runActivity(named: "two arguments") { _ in
            let functionType = try VariableDeclSyntax("var n: (Int, String) -> ()") {}
                .bindings.first!.closure!

            let parameterClause = parameterClause(functionType)

            assertStringsEqualWithDiff(
                parameterClause.formatted().description,
                """
                _, _
                """
            )
        }
    }

    func testPropertyNameRetrievalFromVariableDecl() throws {
        let variableDecl = try VariableDeclSyntax("var foo: () -> ()") {}

        let text = propertyNameTokenSyntax(variableDecl.bindings.first!)!.text

        XCTAssertEqual(text, "foo")
    }
}
