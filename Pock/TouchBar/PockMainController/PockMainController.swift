//
//  PockMainController.swift
//  Pock
//
//  Created by Pierluigi Galdi on 21/10/2018.
//  Copyright © 2018 Pierluigi Galdi. All rights reserved.
//

import Foundation
import PockKit

/// Custom identifiers
extension NSTouchBar.CustomizationIdentifier {
    static let pockTouchBar = "PockTouchBar"
}
extension NSTouchBarItem.Identifier {
    static let pockSystemIcon = NSTouchBarItem.Identifier("Pock")
    static let dockView       = NSTouchBarItem.Identifier("Dock")
    static let escButton      = NSTouchBarItem.Identifier("Esc")
    static let controlCenter  = NSTouchBarItem.Identifier("ControlCenter")
    static let nowPlaying     = NSTouchBarItem.Identifier("NowPlaying")
    static let status         = NSTouchBarItem.Identifier("Status")
}

class PockMainController: PKTouchBarController {
    
    override var systemTrayItem: NSCustomTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: .pockSystemIcon)
        item.view = NSButton(image: #imageLiteral(resourceName: "pock-inner-icon"), target: self, action: #selector(presentFromSystemTrayItem))
        return item
    }
    override var systemTrayItemIdentifier: NSTouchBarItem.Identifier? { return .pockSystemIcon }
    
    deinit {
        WidgetsDispatcher.default.clearLoadedWidgets()
        if !isProd { print("[PockMainController]: Deinit Pock main controller") }
    }
    
    override func didLoad() {
        WidgetsDispatcher.default.loadInstalledWidget() { widgets in
            self.touchBar?.customizationIdentifier              = .pockTouchBar
            self.touchBar?.defaultItemIdentifiers               = [.nowPlaying, .dockView, .controlCenter, .status]
            self.touchBar?.customizationAllowedItemIdentifiers  = [.escButton, .dockView, .controlCenter, .nowPlaying, .status]

            let customizableIds: [NSTouchBarItem.Identifier] = widgets.map({ $0.identifier })
            self.touchBar?.customizationAllowedItemIdentifiers.append(contentsOf: customizableIds)

            super.awakeFromNib()
        }
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        var widget: PKWidget?
        switch identifier {
        /// Esc button
        case .escButton:
            widget = EscWidget()
        /// Dock widget
        case .dockView:
            widget = DockWidget()
        /// ControlCenter widget
        case .controlCenter:
            widget = ControlCenterWidget()
        /// NowPlaying widget
        case .nowPlaying:
            widget = NowPlayingWidget()
        /// Status widget
        case .status:
            widget = StatusWidget()
        default:
            widget = WidgetsDispatcher.default.loadedWidgets[identifier]
        }
        guard widget != nil else { return nil }
        return PKWidgetTouchBarItem(widget: widget!)
    }
    
}
