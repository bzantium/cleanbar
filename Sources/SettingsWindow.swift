import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @AppStorage("autoHideEnabled") private var autoHideEnabled = false
    @AppStorage("autoHideDelay") private var autoHideDelay = 10.0
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("showSeparator") private var showSeparator = true

    var body: some View {
        Form {
            Section {
                Toggle("Launch at login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { newValue in
                        setLaunchAtLogin(newValue)
                    }

                Toggle("Show separator line", isOn: $showSeparator)
            } header: {
                Text("General")
            }

            Section {
                Toggle("Auto-hide after expanding", isOn: $autoHideEnabled)

                if autoHideEnabled {
                    HStack {
                        Text("Delay")
                        Slider(value: $autoHideDelay, in: 1...30, step: 1)
                        Text("\(Int(autoHideDelay))s")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            } header: {
                Text("Auto-hide")
            }

            Section {
                HStack {
                    Text("Toggle hidden items")
                    Spacer()
                    Text("Click menu bar icon")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Usage")
            } footer: {
                Text("Cmd+drag menu bar icons to rearrange. Place icons between the separator (|) and toggle arrow (≫) to hide them.")
                    .foregroundStyle(.tertiary)
            }
        }
        .formStyle(.grouped)
        .frame(width: 380, height: 320)
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            // Silently handle - will fail if not a proper app bundle
        }
    }
}

class SettingsWindowController {
    private var window: NSWindow?

    func showSettings() {
        if let window = window, window.isVisible {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let hostingController = NSHostingController(rootView: SettingsView())
        let window = NSWindow(contentViewController: hostingController)
        window.title = "CleanBar Settings"
        window.styleMask = [.titled, .closable]
        window.center()
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        self.window = window
    }
}
