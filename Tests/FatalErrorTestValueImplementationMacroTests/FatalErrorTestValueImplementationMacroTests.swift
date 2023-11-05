import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(FatalErrorTestValueImplementationMacro)
import FatalErrorTestValueImplementationMacro

let testMacros: [String: Macro.Type] = [
    "FatalTestValue": FatalErrorTestValueImplementationMacro.self,
]
#endif

final class FatalErrorTestValueImplementationMacroTests: XCTestCase {

    func testExpansionWhenOneClosureExpandsCorrectly() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
        assertMacroExpansion(
            """
            @FatalTestValue
            struct Example {
                var foo: (Int) async throws -> Void
            }
            """,
            expandedSource: """
            struct Example {
                var foo: (Int) async throws -> Void
            }

            extension Example {
                public static let testValue = Example(
                    foo: { _ in
                        fatalError()
                    }
                )
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testExpansionForChainedClosuresExpandsCorrectly() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
        assertMacroExpansion(
            """
            @FatalTestValue
            struct Example {
                var foo: () async throws -> Void, bar: () -> ()
            }
            """,
            expandedSource: """
            struct Example {
                var foo: () async throws -> Void, bar: () -> ()
            }

            extension Example {
                public static let testValue = Example(
                    foo: {
                        fatalError()
                    },
                    bar: {
                        fatalError()
                    }
                )
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    func testExpansionWhenOneClosureAndInnerDeclExpandsCorrectly() throws {
#if canImport(FatalErrorTestValueImplementationMacro)

        XCTContext.runActivity(named: "function") { _ in
            assertMacroExpansion(
            """
            @FatalTestValue
            struct Example {
                func method() -> Int
                var foo: @Sendable (Int) async throws -> Void
            }
            """,
            expandedSource: """
            struct Example {
                func method() -> Int
                var foo: @Sendable (Int) async throws -> Void
            }

            extension Example {
                public static let testValue = Example(
                    foo: { _ in
                        fatalError()
                    }
                )
            }
            """,
            macros: testMacros
            )
        }

        XCTContext.runActivity(named: "enum") { _ in
            assertMacroExpansion(
            """
            @FatalTestValue
            struct Example {
                enum Error { case dummy }
                var foo: @Sendable (Int) async throws -> Void
            }
            """,
            expandedSource: """
            struct Example {
                enum Error { case dummy }
                var foo: @Sendable (Int) async throws -> Void
            }

            extension Example {
                public static let testValue = Example(
                    foo: { _ in
                        fatalError()
                    }
                )
            }
            """,
            macros: testMacros
            )
        }

#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    func testExpansionWhenOneClosureWithTwoArgumentsExpandsCorrectly() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
        assertMacroExpansion(
            """
            @FatalTestValue
            struct Example {
                var foos: @Sendable (Int, Int) async throws -> Void
            }
            """,
            expandedSource: """
            struct Example {
                var foos: @Sendable (Int, Int) async throws -> Void
            }

            extension Example {
                public static let testValue = Example(
                    foos: { _, _ in
                        fatalError()
                    }
                )
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testExpansionWhenTwoClosureWithTwoArgumentsExpandsCorrectly() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
        assertMacroExpansion(
            """
            @FatalTestValue
            struct Example {
                var refresh: @Sendable () async throws -> Void
                var removeItems: @Sendable (Int, Int) async throws -> Void
            }
            """,
            expandedSource: """
            struct Example {
                var refresh: @Sendable () async throws -> Void
                var removeItems: @Sendable (Int, Int) async throws -> Void
            }

            extension Example {
                public static let testValue = Example(
                    refresh: {
                        fatalError()
                    },
                    removeItems: { _, _ in
                        fatalError()
                    }
                )
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMacroDoesNothingWhenNoFunction() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
        XCTContext.runActivity(named: "struct") { _ in
            assertMacroExpansion(
            """
            @FatalTestValue
            struct Example {
            }
            """,
            expandedSource: """
            struct Example {
            }
            """,
            macros: testMacros
            )
        }

        XCTContext.runActivity(named: "class") { _ in
            assertMacroExpansion(
            """
            @FatalTestValue
            class Example {
            }
            """,
            expandedSource: """
            class Example {
            }
            """,
            macros: testMacros
            )
        }
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testExpansionWhenAttachedToClassOrStructProducesDiagnostic() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
        XCTContext.runActivity(named: "protocol") { _ in
            assertMacroExpansion(
                """
                @FatalTestValue
                protocol Example {
                }
                """,
                expandedSource: """
                protocol Example {
                }
                """,
                diagnostics: [
                    DiagnosticSpec(
                        message: "This macro can be applied to a class or struct",
                        line: 1,
                        column: 1
                    )
                ],
                macros: testMacros
            )
        }

        XCTContext.runActivity(named: "actor") { _ in
            assertMacroExpansion(
                """
                @FatalTestValue
                actor Example {
                }
                """,
                expandedSource: """
                actor Example {
                }
                """,
                diagnostics: [
                    DiagnosticSpec(
                        message: "This macro can be applied to a class or struct",
                        line: 1,
                        column: 1
                    )
                ],
                macros: testMacros
            )
        }
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testExpansionWithNonClosureMemberYieldsDiagnostic() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
        XCTContext.runActivity(named: "var") { _ in
            assertMacroExpansion(
            """
            @FatalTestValue
            struct Example {
                var id: Int
                var removeItem: @Sendable (Int) async throws -> Void
            }
            """,
            expandedSource: """
            struct Example {
                var id: Int
                var removeItem: @Sendable (Int) async throws -> Void
            }

            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "This macro cannot be applied to types with members that are not closures",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
            )
        }

        XCTContext.runActivity(named: "tuple") { _ in
            assertMacroExpansion(
            """
            @FatalTestValue
            struct Example {
                var (String, Int) = ("", 1)
                var removeItem: @Sendable (Int) async throws -> Void
            }
            """,
            expandedSource: """
            struct Example {
                var (String, Int) = ("", 1)
                var removeItem: @Sendable (Int) async throws -> Void
            }

            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "This macro cannot be applied to types with members that are not closures",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
            )
        }
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
