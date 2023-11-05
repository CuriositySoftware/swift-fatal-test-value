# swift-fatal-test-value

This macro eliminates boilerplate needed to set initial values of Dependency Injected instances' methods in unit tests.
By simply annotating a struct or class with `@FatalTestValue`, it auto-generates an initializer invoking `fatalError()` for the closure.

## Quick start

To get started, import FatalTestValue: `import FatalTestValue`, annotate your struct or class  with `@FatalTestValue`:

```swift
import FatalTestValue

@FatalTestValue
struct Example {
    var create: @Sendable (Int) async throws -> Void
    var read: @Sendable (Int) async throws -> String
    var update: @Sendable (Int, String) async throws -> Void
    var delete: (Int) -> Void
}
```

This will automatically generate an extension with a `testValue` property.


```swift
extension Example {
    public static let testValue = Example(
        create: { _ in
            fatalError()
        },
        read: { _ in
            fatalError()
        },
        update: { _, _ in
            fatalError()
        },
        delete: { _ in
            fatalError()
        }
    )
}
```
