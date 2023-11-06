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

}

extension FatalErrorTestValueImplementationMacroTests {

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

    func testExpansionWhenFunctionAndOneClosureExpandsCorrectly() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
        // Test expansion for the function and closure part
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
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testExpansionWhenEnumAndInnerDeclExpandsCorrectly() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
        // Test expansion for the enum and inner declaration part
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
}

extension FatalErrorTestValueImplementationMacroTests {

    func testMacroDoesNothingWhenNoFunctionInStruct() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
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
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testMacroDoesNothingWhenNoFunctionInClass() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
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
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}

extension FatalErrorTestValueImplementationMacroTests {

    func testExpansionWhenAttachedToProtocolProducesDiagnostic() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
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
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testExpansionWhenAttachedToActorProducesDiagnostic() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
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
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testExpansionWithVariableNonClosureMemberYieldsDiagnostic() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
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
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testExpansionWithTupleNonClosureMemberYieldsDiagnostic() throws {
#if canImport(FatalErrorTestValueImplementationMacro)
        assertMacroExpansion(
        """
        @FatalTestValue
        struct Example {
            var (name: String, id: Int) = ("", 1)
            var removeItem: @Sendable (Int) async throws -> Void
        }
        """,
        expandedSource: """
        struct Example {
            var (name: String, id: Int) = ("", 1)
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
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
