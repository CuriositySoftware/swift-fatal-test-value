import SwiftSyntax
import SwiftSyntaxBuilder

func parameterClause(
    _ functionType: FunctionTypeSyntax
) -> ClosureSignatureSyntax.ParameterClause {
    if functionType.parameters.count == 0 {
        return ClosureSignatureSyntax.ParameterClause.simpleInput(
            .init([])
        )
    } 

    return ClosureSignatureSyntax.ParameterClause.simpleInput(
        .init(
            functionType.parameters.enumerated().map { (index, _) in
                let isLast = (index == functionType.parameters.count - 1)
                return .init(
                    name: .wildcardToken(),
                    trailingComma: isLast ? nil : .commaToken()
                )
            }
        )
    )
}

func propertyNameTokenSyntax(_ syntax: PatternBindingSyntax) -> TokenSyntax? {
    guard
        let identifierPattern = syntax.pattern.as(IdentifierPatternSyntax.self)
    else {
        return nil
    }

    return identifierPattern.identifier
}
