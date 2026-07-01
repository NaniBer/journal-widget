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
    var timer: Timer?
    var lastFrontmostApp: String = ""
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide from Dock
        NSApplication.shared.setActivationPolicy(.accessory)
        
        let view = JournalWidgetView()
            .frame(width: 140, height: 100)
        
        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = NSRect(x: 0, y: 0, width: 140, height: 100)
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 140, height: 100),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        window.contentView = hostingView
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.ignoresMouseEvents = false
        window.hidesOnDeactivate = false
        window.isMovable = false
        window.isMovableByWindowBackground = false
        
        // Position on screen
        window.setFrameOrigin(NSPoint(x: 20, y: 400))
        window.makeKeyAndOrderFront(nil)
        
        // Poll every 0.5 seconds to check frontmost app
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkFrontmostApp()
        }
    }
    
    private func checkFrontmostApp() {
        guard let frontmostApp = NSWorkspace.shared.frontmostApplication else { return }
        let bundleId = frontmostApp.bundleIdentifier ?? ""
        
        // Skip if same app as before
        guard bundleId != lastFrontmostApp else { return }
        lastFrontmostApp = bundleId
        
        // Show widget only when Finder (desktop) is frontmost
        if bundleId == "com.apple.finder" {
            DispatchQueue.main.async { [weak self] in
                self?.window.orderFront(nil)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.window.orderOut(nil)
            }
        }
    }
}

struct EmptyView: View {
    var body: some View {
        Text("")
    }
}