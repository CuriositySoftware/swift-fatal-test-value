
@attached(extension, names: arbitrary)
public macro FatalTestValue() = #externalMacro(
    module: "FatalErrorTestValueImplementationMacro",
    type: "FatalErrorTestValueImplementationMacro"
)
