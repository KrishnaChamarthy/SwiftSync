//
//  SwiftSyncApp.swift
//  SwiftSync
//
//  Created by Krishna Chamarthy on 29/05/26.
//

import AppKit
import Combine
import SwiftUI

@main
struct SwiftSyncApp: App {
    @StateObject private var syncManager = SyncManager()

    var body: some Scene {
        MenuBarExtra("SwiftSync", systemImage: syncManager.menuBarSystemImage) {
            MenuBarView()
                .environmentObject(syncManager)
        }
        .menuBarExtraStyle(.menu)

        Window("SwiftSync Settings", id: "settings") {
            SettingsView()
                .environmentObject(syncManager)
        }
        .defaultSize(width: 560, height: 360)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About SwiftSync") {
                    NSApplication.shared.orderFrontStandardAboutPanel()
                }
            }
        }
    }
}

@MainActor
final class SyncManager: ObservableObject {
    @Published var status: SyncStatus = .idle
    @Published var selectedFolderPath: String?

    var menuBarSystemImage: String {
        switch status {
        case .idle:
            return "arrow.triangle.2.circlepath"
        case .watching:
            return "folder.badge.gearshape"
        case .syncing:
            return "icloud.and.arrow.up"
        case .failed:
            return "exclamationmark.icloud"
        }
    }
}

enum SyncStatus: Equatable {
    case idle
    case watching
    case syncing
    case failed(String)

    var title: String {
        switch self {
        case .idle:
            return "Idle"
        case .watching:
            return "Watching"
        case .syncing:
            return "Syncing"
        case .failed:
            return "Needs Attention"
        }
    }

    var detail: String {
        switch self {
        case .idle:
            return "Choose a folder in Settings to begin."
        case .watching:
            return "SwiftSync is monitoring your selected folder."
        case .syncing:
            return "Uploading changed files."
        case .failed(let message):
            return message
        }
    }
}
