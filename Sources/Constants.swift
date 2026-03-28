import AppKit

enum Constants {
    static let toggleAutosaveName = "cleanbar_toggle"
    static let separatorAutosaveName = "cleanbar_separator"

    static let expandedSeparatorLength: CGFloat = 20
    static let collapsedSeparatorLength: CGFloat = 10_000

    static let toggleDebounceInterval: TimeInterval = 0.3

    static let toggleIconSize = NSSize(width: 16, height: 12)
    static let separatorImageSize = NSSize(width: 2, height: 18)

    static let popoverIconSize: CGFloat = 22
}
