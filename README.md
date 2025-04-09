<img src="Images/Animal.png" width="256">

# Swift Mistral

An unofficial Swift client library for interacting with the [Mistral API](https://docs.mistral.ai).

## Requirements

- Swift 5.9+
- iOS 16+
- macOS 13+
- watchOS 9+
- tvOS 16+

## Installation

Add the following to your `Package.swift` file:

```swift
Package(
    dependencies: [
        .package(url: "https://github.com/nathanborror/swift-mistral", branch: "main"),
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "Mistral", package: "swift-mistra"),
            ]
        ),
    ]
)
```

## Usage

### Chat Completion

```swift
import Mistral

let client = Client(apiKey: MISTRAL_API_KEY)

let request = ChatRequest(
    model: "mistral-large-latest",
    messages: [
        .init(role: .system, content: [.init(text: "You are a helpful assistant.")]),
        .init(role: .user, content: [.init(text: "Hello, Mistral!")])
    ]
)

do {
    let response = try await client.chatCompletions(request)
    print(response.completion_message.content.text)
} catch {
    print(error)
}
```

### List Models

```swift
import Mistral

let client = Client(apiKey: MISTRAL_API_KEY)

do {
    let response = try await client.models()
    print(response.data.map { $0.id }.joined(separator: "\n"))
} catch {
    print(error)
}
```

### Command Line Interface

```
$ make
$ ./mistral
OVERVIEW: A utility for interacting with the Mistral API.

USAGE: mistral <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  models                  Returns available models.
  chat-completion         Completes a chat request.

  See 'cli help <subcommand>' for detailed help.
```
