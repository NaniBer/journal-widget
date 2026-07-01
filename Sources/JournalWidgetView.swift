import SwiftUI

struct JournalWidgetView: View {
    @State private var hasJournaledToday: Bool = false
    @State private var showCelebration: Bool = false
    
    private let vaultPath = "/Users/mac/Documents/Nan's corner/Inside My Brain"
    
    private var todayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private var journalFilePath: String {
        "\(vaultPath)/\(todayString).md"
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .shadow(radius: 2)
            
            VStack(spacing: 8) {
                if showCelebration {
                    celebrationView
                } else if hasJournaledToday {
                    doneView
                } else {
                    promptView
                }
            }
            .padding(14)
        }
        .fixedSize()
        .onAppear {
            checkIfJournaled()
        }
    }
    
    private var promptView: some View {
        VStack(spacing: 10) {
            Image(systemName: "pencil.and.scribble")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.accentColor)
            
            Text("Journaled today?")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.primary)
            
            Button(action: openOrCreateJournal) {
                HStack(spacing: 6) {
                    Image(systemName: "note.text.badge.plus")
                        .font(.system(size: 10, weight: .medium))
                    Text("Open Journal")
                        .font(.system(size: 10, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.accentColor)
                .cornerRadius(7)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var doneView: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 22))
                .foregroundColor(.green)
            
            Text("Done for today")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
            
            Button(action: openOrCreateJournal) {
                HStack(spacing: 5) {
                    Image(systemName: "note.text")
                        .font(.system(size: 9))
                    Text("View Entry")
                        .font(.system(size: 9, weight: .medium))
                }
                .foregroundColor(.accentColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 5)
                .background(Color.accentColor.opacity(0.15))
                .cornerRadius(6)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var celebrationView: some View {
        VStack(spacing: 6) {
            Text("✨")
                .font(.system(size: 22))
            
            Text("Good job!")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
    
    private func checkIfJournaled() {
        let fileManager = FileManager.default
        hasJournaledToday = fileManager.fileExists(atPath: journalFilePath)
    }
    
    private func openOrCreateJournal() {
        let fileManager = FileManager.default
        
        // Create file if it doesn't exist
        if !fileManager.fileExists(atPath: journalFilePath) {
            // Ensure directory exists
            if !fileManager.fileExists(atPath: vaultPath) {
                try? fileManager.createDirectory(atPath: vaultPath, withIntermediateDirectories: true)
            }
            
            // Create empty file
            fileManager.createFile(atPath: journalFilePath, contents: nil, attributes: nil)
            
            // Show celebration
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showCelebration = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showCelebration = false
                    hasJournaledToday = true
                }
            }
        }
        
        // Open in Obsidian using vault ID and relative path
        let vaultID = "655170984f3201ca"
        let relativePath = "Inside My Brain/\(todayString)"
        
        if let encodedPath = relativePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let obsidianURL = "obsidian://open?vault=\(vaultID)&file=\(encodedPath)"
            if let url = URL(string: obsidianURL) {
                NSWorkspace.shared.open(url)
            }
        }
    }
}