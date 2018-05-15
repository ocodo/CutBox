//
//  SearchViewControllerTableViewDelegate.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension SearchViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.historyService.count
    }
}

extension SearchViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        self.updatePreview()
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = ClipItemTableRowContainerView()
        rowView.searchView = self.searchView
        return rowView
    }

    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let record = self.historyService.dict[safe: row] else { return nil }
        guard let column = tableColumn else { return nil }

        let theme = CutBoxPreferencesService.shared.currentTheme

        switch column.identifier.rawValue {
        case "icon":
            let rowView = tableView.getRowView() as ClipItemTableRowImageView
            rowView.data = record
            rowView.color = theme.clip.clipItemsTextColor
            return rowView

        case "string":
            let rowView = tableView.getRowView() as ClipItemTableRowTextView
            rowView.data = record
            rowView.color = theme.clip.clipItemsTextColor
            return rowView

        default:
            return nil
        }
    }

    func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
        let proposed = proposedSelectionIndexes

        guard proposed.count > 0 else { return proposedSelectionIndexes }

        let selected =  self.searchView.clipboardItemsTable.selectedRowIndexes
        let removed: IndexSet = selected.subtracting(proposed)
        let added: IndexSet = proposed.subtracting(selected)

        added.forEach { self.orderedSelection.add($0) }
        removed.forEach { self.orderedSelection.remove($0) }

        var cruft: [Int] = []

        self.orderedSelection.all().forEach {
            if !proposed.contains($0) {
                cruft.append($0)
            }
        }

        cruft.forEach { self.orderedSelection.remove($0) }

        return proposedSelectionIndexes
    }
}
