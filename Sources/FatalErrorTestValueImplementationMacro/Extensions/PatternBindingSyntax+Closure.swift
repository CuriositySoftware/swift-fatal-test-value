import SwiftSyntax

extension PatternBindingSyntax {
    var isClosure: Bool {
        return closure != nil
    }

    var closure: FunctionTypeSyntax? {
        guard let typeAnnotation else {
            return nil
        }

        if let type = typeAnnotation.type.as(AttributedTypeSyntax.self),
           let functionType = type.baseType.as(FunctionTypeSyntax.self) {
            // example: @Sendable @escaping () -> ()
            return functionType
        } else if let functionType = typeAnnotation.type.as(FunctionTypeSyntax.self) {
            // example: () -> ()
            return functionType
        }

        return nil
    }
}

