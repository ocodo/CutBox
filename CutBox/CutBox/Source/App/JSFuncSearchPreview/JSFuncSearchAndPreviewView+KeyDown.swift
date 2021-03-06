//
//  JSFuncSearchAndPreviewView+KeyDown.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import RxSwift
import Carbon.HIToolbox

extension JSFuncSearchAndPreviewView {

    override func keyDown(with event: NSEvent) {
        switch (event.key, event.modifiers) {
        case (kVK_UpArrow, _),
             (kVK_DownArrow, _):
            self.hideItemsAndPreview(false)
            if !JSFuncService.shared.isEmpty {
                self.itemsList.keyDown(with: event)
            }

        case (kVK_ANSI_T, [.command]):
            self.events
                .onNext(.toggleTheme)

        case (kVK_Return, _):
            self.events.onNext(.closeAndPaste)

        case (kVK_Escape, _):
            self.events.onNext(.justClose)

        default:
            break
        }
    }

}
