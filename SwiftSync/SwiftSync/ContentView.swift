//
//  ContentView.swift
//  SwiftSync
//
//  Created by Krishna Chamarthy on 29/05/26.
//

import AppKit
import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject private var syncManager: SyncManager
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(syncManager.status.title, systemImage: syncManager.menuBarSystemImage)
                .font(.headline)

            Text(syncManager.status.detail)
                .font(.caption)
                .foregroundStyle(.secondary)

            if let selectedFolderPath = syncManager.selectedFolderPath {
                Divider()
                Text(selectedFolderPath)
                    .font(.caption)
                    .lineLimit(2)
                    .truncationMode(.middle)
            }

            Divider()

            Button("Settings...") {
                NSApplication.shared.activate(ignoringOtherApps: true)
                openWindow(id: "settings")
            }

            Button("Quit SwiftSync") {
                NSApplication.shared.terminate(nil)
            }
        }
        .frame(width: 260, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

struct SettingsView: View {
    @EnvironmentObject private var syncManager: SyncManager

    var body: some View {
        Form {
            Section("Cloud") {
                TextField("S3 Endpoint", text: .constant(""))
                TextField("Bucket", text: .constant(""))
                SecureField("Access Key", text: .constant(""))
                SecureField("Secret Key", text: .constant(""))
            }

            Section("Local Folder") {
                HStack {
                    Text(syncManager.selectedFolderPath ?? "No folder selected")
                        .foregroundStyle(syncManager.selectedFolderPath == nil ? .secondary : .primary)
                        .lineLimit(1)
                        .truncationMode(.middle)

                    Spacer()

                    Button("Choose...") {
                        chooseFolder()
                    }
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 520)
        .padding()
    }

    private func chooseFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        panel.prompt = "Choose"

        guard panel.runModal() == .OK, let folderURL = panel.url else {
            return
        }

        syncManager.selectedFolderPath = folderURL.path
        syncManager.status = .watching
    }
}
