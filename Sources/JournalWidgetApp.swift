import SwiftUI

@main
struct JournalWidgetApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide from Dock
        NSApplication.shared.setActivationPolicy(.accessory)
        
        let view = JournalWidgetView()
            .frame(width: 140, height: 100)
        
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = NSRect(x: 0, y: 0, width: 140, height: 100)
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 140, height: 100),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.contentView = hostingView
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        
        // Desktop level - behind all windows
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)))
        
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        window.ignoresMouseEvents = false
        window.acceptsMouseMovedEvents = true
        
        // Fixed position - not movable
        window.isMovable = false
        window.isMovableByWindowBackground = false
        
        // Position on screen (higher up, left side)
        window.setFrameOrigin(NSPoint(x: 20, y: 400))
        
        window.orderFront(nil)
    }
}

struct EmptyView: View {
    var body: some View {
        Text("")
    }
}