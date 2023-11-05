#if canImport(SwiftCompilerPlugin)
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct PropertyFatalErrorCompilerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FatalErrorTestValueImplementationMacro.self
    ]
}
#endif
