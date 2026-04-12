# MDView

A SwiftUI-based Markdown viewer and editor application for macOS.

## Features

- View and edit Markdown files
- Real-time Markdown preview with syntax highlighting
- Document-based app with file operations (open, save, save as)
- Clean, modern UI

## Requirements

- macOS 13.0+
- Xcode 15.0+

## Building from Command Line

Build a Debug build:

```bash
xcodebuild -project mdview.xcodeproj -scheme mdview build
```

Build a Release build:

```bash
xcodebuild -project mdview.xcodeproj -scheme mdview -configuration Release build
```

Clean and build:

```bash
xcodebuild -project mdview.xcodeproj -scheme mdview -configuration Release clean build
```

The built application will be located at:
```
build/Release/mdview.app
```

## Dependencies

This project uses [markdown-markdown-ui](https://github.com/gonzalezreal/swift-markdown-ui) for Markdown rendering.

## License

This project is licensed under the GPL v3 License.
