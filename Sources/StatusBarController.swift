import AppKit

class StatusBarController: NSObject, NSMenuDelegate {
    private let toggleItem: NSStatusItem
    private let separatorItem: NSStatusItem
    private var isCollapsed: Bool = true
    private var isToggling: Bool = false
    private let settingsWindowController = SettingsWindowController()
    private let shortcutManager = KeyboardShortcutManager()
    private var autoHideTimer: Timer?
    private var preferencesObserver: NSObjectProtocol?

    override init() {
        toggleItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        separatorItem = NSStatusBar.system.statusItem(withLength: Constants.expandedSeparatorLength)

        super.init()

        toggleItem.autosaveName = Constants.toggleAutosaveName
        separatorItem.autosaveName = Constants.separatorAutosaveName

        setupToggleButton()
        setupSeparator()
        collapse()

        shortcutManager.register { [weak self] in
            self?.toggleClicked(nil)
        }

        preferencesObserver = NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateSeparatorVisibility()
        }
    }

    deinit {
        if let observer = preferencesObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        stopAutoHideTimer()
    }

    // MARK: - Setup

    private func setupToggleButton() {
        guard let button = toggleItem.button else { return }
        button.action = #selector(handleToggleClick(_:))
        button.target = self
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

    private func setupSeparator() {
        guard let button = separatorItem.button else { return }
        button.image = makeSeparatorImage()
        button.action = #selector(toggleClicked(_:))
        button.target = self
    }

    // MARK: - Click Handling

    @objc private func handleToggleClick(_ sender: Any?) {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp {
            showContextMenu()
        } else {
            toggleClicked(sender)
        }
    }

    private func showContextMenu() {
        let menu = NSMenu()
        menu.delegate = self

        let stateItem = NSMenuItem(
            title: isCollapsed ? "Show Hidden Icons" : "Hide Icons",
            action: #selector(toggleClicked(_:)),
            keyEquivalent: ""
        )
        stateItem.target = self
        menu.addItem(stateItem)

        menu.addItem(.separator())

        let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "Quit CleanBar", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        toggleItem.menu = menu
        toggleItem.button?.performClick(nil)
    }

    func menuDidClose(_ menu: NSMenu) {
        toggleItem.menu = nil
    }

    @objc private func openSettings() {
        settingsWindowController.showSettings()
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    // MARK: - Toggle (simple inline expand/collapse)

    @objc private func toggleClicked(_ sender: Any?) {
        guard !isToggling else { return }
        isToggling = true

        if isCollapsed {
            expand()
        } else {
            collapse()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.toggleDebounceInterval) { [weak self] in
            self?.isToggling = false
        }
    }

    private func collapse() {
        separatorItem.length = Constants.collapsedSeparatorLength
        isCollapsed = true
        updateToggleIcon()
        updateSeparatorVisibility()
        stopAutoHideTimer()
    }

    private func expand() {
        separatorItem.length = Constants.expandedSeparatorLength
        isCollapsed = false
        updateToggleIcon()
        updateSeparatorVisibility()
        startAutoHideTimer()
    }

    // MARK: - Auto-hide Timer

    private func startAutoHideTimer() {
        stopAutoHideTimer()
        guard Preferences.autoHideEnabled else { return }
        autoHideTimer = Timer.scheduledTimer(withTimeInterval: Preferences.autoHideDelay, repeats: false) { [weak self] _ in
            self?.collapse()
        }
    }

    private func stopAutoHideTimer() {
        autoHideTimer?.invalidate()
        autoHideTimer = nil
    }

    // MARK: - UI

    private func updateToggleIcon() {
        guard let button = toggleItem.button else { return }
        let symbolName = isCollapsed ? "chevron.right.2" : "chevron.left.2"
        let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "Toggle hidden icons")
        image?.size = Constants.toggleIconSize
        button.image = image
    }

    private func updateSeparatorVisibility() {
        guard let button = separatorItem.button else { return }
        if !isCollapsed && Preferences.showSeparator {
            button.image = makeSeparatorImage()
        } else {
            button.image = nil
        }
    }

    private func makeSeparatorImage() -> NSImage {
        let image = NSImage(size: Constants.separatorImageSize, flipped: false) { rect in
            NSColor.tertiaryLabelColor.setFill()
            let insetRect = NSRect(x: 0, y: 3, width: rect.width, height: rect.height - 6)
            NSBezierPath(roundedRect: insetRect, xRadius: 1, yRadius: 1).fill()
            return true
        }
        image.isTemplate = true
        return image
    }
}
