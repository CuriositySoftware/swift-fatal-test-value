import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
import _SwiftSyntaxTestSupport
@testable import FatalErrorTestValueImplementationMacro

final class UtilityTests: XCTestCase {
    func testParameterClauseReturnsEmptyStringForClosureWithoutArguments() throws {
        let functionType = try VariableDeclSyntax("var foo: () -> ()") {}
            .bindings.first!.closure!

        let parameterClause = parameterClause(functionType)

        assertStringsEqualWithDiff(
            parameterClause.formatted().description,
                """
                """
        )
    }

    func testParameterClauseWithOneArgumentReturnsWildcard() throws {
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

    func testParameterClauseWithTwoArgumentsReturnsWildcard() throws {
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

    func testPropertyNameRetrievalFromVariableDecl() throws {
        let variableDecl = try VariableDeclSyntax("var foo: () -> ()") {}

        let text = propertyNameTokenSyntax(variableDecl.bindings.first!)!.text

        XCTAssertEqual(text, "foo")
    }
}
