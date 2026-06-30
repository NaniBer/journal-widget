import SwiftUI
import CryptoKit

struct JournalWidgetView: View {
    @State private var hasJournaledToday: Bool = false
    @State private var showPasswordPrompt: Bool = false
    @State private var enteredPassword: String = ""
    @State private var showWrongPassword: Bool = false
    
    // SHA256 hash of the password "journal" - change this to set your own password
    // To generate a new hash: echo -n "yourpassword" | shasum -a 256
    private let passwordHash = "a2b14f5e78e8a8e6c8f8b8c8d8e8f8a8b8c8d8e8f8a8b8c8d8e8f8a8b8c8d8e8" // placeholder
    
    private let vaultPath = "/Users/mac/Documents/Nan's corner/Inside My Brain" // Replace with your actual vault path
    
    private let correctPassword = "123456789" // Replace with your actual password
    
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
               if hasJournaledToday {
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
        .sheet(isPresented: $showPasswordPrompt) {
            passwordPromptView
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
            
            Button(action: { showPasswordPrompt = true }) {
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
            
            Button(action: { showPasswordPrompt = true }) {
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
    

    private var passwordPromptView: some View {
        VStack(spacing: 16) {
            Text("Enter Password")
                .font(.system(size: 14, weight: .semibold))
            
            SecureField("Password", text: $enteredPassword)
                .textFieldStyle(.roundedBorder)
                .frame(width: 180)
                .onSubmit {
                    verifyPassword()
                }
            
            if showWrongPassword {
                Text("Wrong password")
                    .font(.system(size: 10))
                    .foregroundColor(.red)
            }
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    enteredPassword = ""
                    showWrongPassword = false
                    showPasswordPrompt = false
                }
                .keyboardShortcut(.escape)
                
                Button("Unlock") {
                    verifyPassword()
                }
                .keyboardShortcut(.return)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(24)
        .frame(width: 260, height: 200)
    }
    
    private func verifyPassword() {
        if enteredPassword == correctPassword {
            enteredPassword = ""
            showWrongPassword = false
            showPasswordPrompt = false
            openOrCreateJournal()
        } else {
            showWrongPassword = true
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
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