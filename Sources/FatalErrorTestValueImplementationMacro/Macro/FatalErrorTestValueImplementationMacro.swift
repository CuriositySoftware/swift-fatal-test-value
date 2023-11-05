import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftCompilerPlugin
import SwiftSyntaxBuilder

public struct FatalErrorTestValueImplementationMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {

        guard
            declaration.is(StructDeclSyntax.self) ||
            declaration.is(ClassDeclSyntax.self)
        else {
            throw Diagnostics.appliedTypeFail
        }

        let variableDeclarations = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }

        guard !variableDeclarations.isEmpty else {
            return []
        }

        let closureDeclarations = variableDeclarations
            .flatMap { $0.bindings }
            .filter { $0.pattern.is(IdentifierPatternSyntax.self) && $0.isClosure }

        guard 
            closureDeclarations.count == variableDeclarations.flatMap({ $0.bindings }).count
        else {
            throw Diagnostics.appliedMemberFail
        }

        return [
            makeExtensionDeclSyntax(
                extendedType: type,
                closureDeclarations: closureDeclarations
            )
            .formatted()
            .as(ExtensionDeclSyntax.self)!
        ]
    }
}

private extension FatalErrorTestValueImplementationMacro {
    static func makeExtensionDeclSyntax(
        extendedType: some TypeSyntaxProtocol,
        closureDeclarations: [PatternBindingSyntax]
    ) -> ExtensionDeclSyntax {
        .init(
            extendedType: extendedType,
            memberBlock: MemberBlockSyntax {
                VariableDeclSyntax(
                    modifiers: [
                        DeclModifierSyntax(name: .keyword(.public)),
                        DeclModifierSyntax(name: .keyword(.static))
                    ],
                    bindingSpecifier: .keyword(.let)
                ) {
                    PatternBindingSyntax(
                        pattern: PatternSyntax("testValue"),
                        initializer: InitializerClauseSyntax(
                            value: FunctionCallExprSyntax(
                                calledExpression: DeclReferenceExprSyntax(
                                    baseName: TokenSyntax(
                                        stringLiteral: String(describing: extendedType)
                                    )
                                ),
                                leftParen: TokenSyntax(
                                    TokenKind.leftParen, // (
                                    presence: .present
                                ),
                                arguments: LabeledExprListSyntax(
                                    itemsBuilder: {
                                        for member in closureDeclarations {
                                            makeLabeledExprSyntax(member)
                                        }
                                    }
                                ),
                                rightParen: TokenSyntax( // )
                                    TokenKind.rightParen,
                                    leadingTrivia: .newline,
                                    presence: .present
                                )
                            )
                        )
                    )
                }
            }
        )
    }

    static func makeLabeledExprSyntax(_ member: PatternBindingSyntax) -> LabeledExprSyntax {
        guard let functionType = member.closure else {
            fatalError()
        }

        return .init(
            leadingTrivia: .newline,
            label: propertyNameTokenSyntax(member)!,
            colon: TokenSyntax(
                TokenSyntax.colonToken()
            ),
            expression: ClosureExprSyntax(
                signature: ClosureSignatureSyntax(
                    leadingTrivia: .spaces(1),
                    attributes: [],
                    parameterClause: parameterClause(
                        functionType
                    ),
                    returnClause: nil,
                    inKeyword: .keyword(
                        .in,
                        leadingTrivia: .spaces(1),
                        presence: functionType.parameters.count > 0 ? .present : .missing
                    )
                ),
                statements: makeFatalErrorItemListSyntax()
            )
        )
    }

    static func makeFatalErrorItemListSyntax() -> CodeBlockItemListSyntax {
        .init(
            itemsBuilder: {
                FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(
                        baseName: TokenSyntax(
                            stringLiteral: "fatalError()"
                        )
                    ), argumentsBuilder: {}
                )
            }
        )
    }
}
