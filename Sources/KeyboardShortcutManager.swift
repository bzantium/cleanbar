import AppKit
import Carbon.HIToolbox

class KeyboardShortcutManager {
    private var eventHotKeyRef: EventHotKeyRef?
    private var eventHandlerRef: EventHandlerRef?
    private var handler: (() -> Void)?

    // Default: Cmd+Shift+B
    private static let defaultKeyCode: UInt32 = UInt32(kVK_ANSI_B)
    private static let defaultModifiers: UInt32 = UInt32(cmdKey | shiftKey)

    fileprivate static var sharedInstance: KeyboardShortcutManager?

    init() {
        KeyboardShortcutManager.sharedInstance = self
    }

    deinit {
        unregister()
        KeyboardShortcutManager.sharedInstance = nil
    }

    func register(handler: @escaping () -> Void) {
        self.handler = handler
        unregister()

        // Install Carbon event handler
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )

        InstallEventHandler(
            GetApplicationEventTarget(),
            hotKeyHandler,
            1,
            &eventType,
            nil,
            &eventHandlerRef
        )

        // Register the hotkey (Cmd+Shift+B)
        let hotKeyID = EventHotKeyID(
            signature: OSType(0x434C4E42), // "CLNB"
            id: 1
        )

        RegisterEventHotKey(
            Self.defaultKeyCode,
            Self.defaultModifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &eventHotKeyRef
        )
    }

    func unregister() {
        if let ref = eventHotKeyRef {
            UnregisterEventHotKey(ref)
            eventHotKeyRef = nil
        }
        if let ref = eventHandlerRef {
            RemoveEventHandler(ref)
            eventHandlerRef = nil
        }
    }

    fileprivate func handleHotKey() {
        handler?()
    }
}

private func hotKeyHandler(
    nextHandler: EventHandlerCallRef?,
    event: EventRef?,
    userData: UnsafeMutableRawPointer?
) -> OSStatus {
    KeyboardShortcutManager.sharedInstance?.handleHotKey()
    return noErr
}
