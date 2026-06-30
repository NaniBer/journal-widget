# Journal Widget

A small macOS desktop widget that reminds you to journal daily. Floating on your desktop with a blur effect, password protected, and integrates with Obsidian.


## Features

- Floating desktop widget (like macOS widgets)
- Password protected
- Opens today's journal entry in Obsidian
- Auto-detects if you've journaled today
- Celebration animation when you start a new entry

## Requirements

- macOS 14.0+
- Xcode Command Line Tools (pre-installed on macOS)
- Obsidian (optional, for journaling)

## Installation

### Clone and Build

```bash
# Clone the repo
git clone https://github.com/NaniBer/journal-widget.git
cd journal-widget

# Build
swift build

# Run
open .build/arm64-apple-macosx/debug/JournalWidget
```

### Create App Bundle (Optional)

To create a clickable app:

```bash
swift build
cp .build/arm64-apple-macosx/debug/JournalWidget JournalWidget.app/Contents/MacOS/
open JournalWidget.app
```

## Configuration

### Set Your Journal Path

Edit `Sources/JournalWidgetView.swift` and update:

```swift
private let vaultPath = "/Users/YOUR_USERNAME/path/to/your/journal/folder"
```

### Set Your Password

Edit `Sources/JournalWidgetView.swift` and update:

```swift
private let correctPassword = "your-password-here"
```

### Set Your Obsidian Vault ID

1. Open `~/Library/Application Support/obsidian/obsidian.json`
2. Find your vault ID
3. Update in `Sources/JournalWidgetView.swift`:

```swift
let vaultID = "your-vault-id"
```

### Set Relative Path (if different)

If your journal files are in a subfolder:

```swift
let relativePath = "Your Subfolder/\(todayString)"
```

## Customization

The widget is built with SwiftUI. Key things you can modify:

- **Size**: Change `frame(width:height:)` in `JournalWidgetApp.swift`
- **Colors**: Modify `Color.accentColor` usage in `JournalWidgetView.swift`
- **Text**: Update strings in `promptView`, `doneView`, `celebrationView`

## Rebuild After Changes

```bash
swift build && cp .build/arm64-apple-macosx/debug/JournalWidget JournalWidget.app/Contents/MacOS/ && open JournalWidget.app
```

## License

MIT
