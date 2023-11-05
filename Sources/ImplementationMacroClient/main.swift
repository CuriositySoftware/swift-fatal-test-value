import FatalTestValue

@FatalTestValue
struct Example {
    var create: @Sendable (Int) async throws -> Void
    var read: @Sendable (Int) async throws -> String
    var update: @Sendable (Int, String) async throws -> Void
    var delete: (Int) -> Void
}
