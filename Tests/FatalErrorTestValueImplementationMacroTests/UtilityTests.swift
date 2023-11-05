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

            assertBuildResult(
                parameterClause,
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

            assertBuildResult(
                parameterClause,
                """
                _
                """
            )
        }

        try XCTContext.runActivity(named: "two arguments") { _ in
            let functionType = try VariableDeclSyntax("var n: (Int, String) -> ()") {}
                .bindings.first!.closure!

            let parameterClause = parameterClause(functionType)

            assertBuildResult(
                parameterClause,
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
