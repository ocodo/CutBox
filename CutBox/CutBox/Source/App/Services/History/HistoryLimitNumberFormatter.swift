//
//  HistoryLimitNumberFormatter.swift
//  CutBox
//
//  Created by Jason on 15/4/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Foundation

class HistoryLimitNumberFormatter: NumberFormatter {

    override var isPartialStringValidationEnabled: Bool {
        set {}
        get {
            return true
        }
    }

    var intOnlyRegex: NSRegularExpression? {
        do {
            return try NSRegularExpression(pattern: "^[0-9]*$",
                                           options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            fatalError("invalid regexp in intOnlyRegex")
        }
    }

    override func isPartialStringValid(_ partialString: String,
                                       newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
                                       errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?)
        -> Bool {
            return intOnlyRegex?.matches(in: partialString,
                                         options: .anchored,
                                         range: NSRange(partialString.startIndex...,
                                                        in: partialString)).count == 1
    }

}
