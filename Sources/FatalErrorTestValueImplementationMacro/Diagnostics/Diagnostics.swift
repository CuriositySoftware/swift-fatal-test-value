import SwiftDiagnostics

private let domain = "FatalTestValue"

enum Diagnostics: String, Error {
    case appliedTypeFail
    case appliedMemberFail
}

extension Diagnostics: DiagnosticMessage {
    var diagnosticID: MessageID {
        MessageID(domain: domain, id: rawValue)
    }

    var message: String {
        switch self {
        case .appliedTypeFail:
            "This macro can be applied to a class or struct"
        case .appliedMemberFail:
            "This macro cannot be applied to types with members that are not closures"
        }
    }

    var severity: DiagnosticSeverity {
        switch self {
        case .appliedTypeFail, .appliedMemberFail:
            .error
        }
    }
}
