//
//  TableDataContainer.swift
//  csenseIosViews
//
//  Created by Kasper T on 04/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import csenseIosBase
import csenseSwift


/**
 * Describes an update performed on a table, so for example if just inserting 1 element then
 * the inserted will contain that path.
 *
 */
public struct TableDataContainerUpdate {
    public let inserted: [IndexPath]
    public let updated: [IndexPath]
    public let removed: [IndexPath]
}

/**
 * Point of the class
 *
 * x) the tableview cannot deal with partial / sparse array of sections,
  but we want that, so we will translate the sectionIndex ( 0-> count of section) into the given key, using
  an ordered Dictionary (so the keys will be sorted).
 */
public class TableDataContainer: NSObject,
        UITableViewDelegate,
        UITableViewDataSource {

    public var delegateSelectionAsTab: Bool = true

    public var removeSelectionAfterSelecting = true

    /**
     * This controls whenever we should crash on bad cells , eg if stuff is really broken
     */
    public var shouldCrashOnBadCell = false

    /**
     * if the shouldCrashOnBadCell is false,
     *  then if this is set to not nil, this will be runned on each "bad" / broken cell
     */
    public var optionalBadCellRender: FunctionResult<UITableView, UITableViewCell>?

    private var headerSections: SortedArray<GenericTableHeaderItem> = SortedArray()

    private var sections: SortedArray<[GenericTableItem]> = SortedArray()

    // MARK: items modifiers
    public func add(item: GenericTableItem, forSection: Int) {
        updateSection(forSection: forSection) { items in
            items += item
        }
    }

    public func add(items: [GenericTableItem], forSection: Int) {
        updateSection(forSection: forSection) { content in
            content += items
        }
    }

    public func removeItemsIn(section: Int) -> [GenericTableItem] {
        return sections.remove(forIndex: section) ?? []
    }

    public func removeItem(atRow: Int, forSection: Int) -> GenericTableItem? {
        var result: GenericTableItem? = nil
        updateSection(forSection: forSection, updateFunction: { content in
            result = content.remove(at: atRow)
        })
        return result
    }

    public func clearItems() {
        sections.removeAll()
    }

    // MARK: section modifiers
    public func clear() {
        clearItems()
        clearHeaders()
    }

    public func remove(section: Int) -> [GenericTableItem] {
        removeHeader(forSection: section)
        return removeItemsIn(section: section)
    }

    // MARK: Table view implementations
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSectionByIndex(index: section).count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return renderItem(tableView: tableView, at: indexPath)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegateSelectionAsTab {
            getSectionRowByIndex(at: indexPath)?.onTappedCalled()
        }
        if removeSelectionAfterSelecting {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getSectionRowByIndex(at: indexPath)?.getCustomHeight() ?? UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return getSectionRowByIndex(at: indexPath)?.getEstimatedHeight() ?? UITableViewAutomaticDimension
    }

    // MARK: rendering and indexing and other for headers.

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerSections.get(forRawIndex: section)?.getTitleForHeader()
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerSections.get(forRawIndex: section)?.getHeaderView()
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return headerSections.get(forRawIndex: section)?.getEstimatedHeightForHeader()
                ?? UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerSections.get(forRawIndex: section)?.getHeaderHeight() ?? 0
    }

    public func setHeader(_ header: GenericTableHeaderItem, forSection: Int) {
        headerSections.set(value: header, forIndex: forSection)
    }

    public func removeHeader(forSection: Int) {
        headerSections.remove(forIndex: forSection)
    }

    public func clearHeaders() {
        headerSections.removeAll()
    }

    public func size(forSection: Int) -> Int {
        return sections.get(forIndex: forSection)?.count ?? 0
    }

    public func getRawSection(forSection: Int) -> Int? {
        return sections.rawIndexOf(forIndex: forSection)
    }

    // MARK: rendering and indexing - for items in sections

    private func getBadTableViewCell(tableView: UITableView, at: IndexPath) -> UITableViewCell {
        Logger.shared.logWarning(message: "Bad cell tried to be render at indexPath:\(at)")
        if (shouldCrashOnBadCell) {
            fatalError("Crashing on bad ui cell, the cell you tried to display was broken;" +
                    " indexPath is: \(at)")
        }
        if let render = optionalBadCellRender {
            return render(tableView)
        } else {
            return UITableViewCell()
        }
    }

    private func updateSection(forSection: Int, updateFunction: MutatingFunction<[GenericTableItem]>) {
        var input = sections.get(forIndex: forSection) ?? []
        updateFunction(&input)
        sections.set(value: input, forIndex: forSection)
    }

    private func getSectionRowByIndex(at: IndexPath) -> GenericTableItem? {
        return sections.get(forRawIndex: at.section)?[at.row]
    }

    private func getSectionByIndex(index: Int) -> [GenericTableItem] {
        return sections.get(forRawIndex: index) ?? []
    }

    private func renderItem(tableView: UITableView, at: IndexPath) -> UITableViewCell {
        let optItem = getSectionRowByIndex(at: at)
        guard let safeItem = optItem else {
            return getBadTableViewCell(tableView: tableView, at: at)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: safeItem.getReuseIdentifier(),
                for: at)
        safeItem.renderFor(cell: cell)
        let updater: EmptyFunction = { [weak tableView] in
            tableView?.reloadRows(at: [at], with: .automatic)
        }
        safeItem.setUpdateFunction(callback: updater)
        return cell
    }
}
