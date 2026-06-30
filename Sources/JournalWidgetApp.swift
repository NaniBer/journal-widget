import SwiftUI

@main
struct JournalWidgetApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Empty - we create window in AppDelegate
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var panel: NSPanel!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let view = JournalWidgetView()
            .frame(width: 140, height: 100)
        
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = NSRect(x: 0, y: 0, width: 140, height: 100)
        
        panel = NSPanel(contentRect: NSRect(x: 100, y: 100, width: 140, height: 100),
                        styleMask: [.borderless, .nonactivatingPanel, .hudWindow],
                        backing: .buffered,
                        defer: false)
        
        panel.contentView = hostingView
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.makeKeyAndOrderFront(nil)
        
        // Position it in a visible spot
        panel.center()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        panel?.close()
    }
}

struct EmptyView: View {
    var body: some View {
        Text("")
    }
}