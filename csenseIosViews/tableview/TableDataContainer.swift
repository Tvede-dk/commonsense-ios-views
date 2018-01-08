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

    private var sections: SortedArray<TableDataSection> = SortedArray()

    // MARK: items modifiers
    public func add(item: GenericTableItem, forSection: Int) -> TableDataSectionUpdate {
        return add(items: [item], forSection: forSection)
    }

    public func add(items: [GenericTableItem], forSection: Int) -> TableDataSectionUpdate {
        let prevSize = size(forSection: forSection)
        guard let rawSection = updateSection(forSection: forSection, updateFunction: { content in
            content += items
        }) else {
            return TableDataSectionUpdate.empty
        }
        //if prev size is zero, then we have created the section
        if prevSize.isZero {
            return TableDataSectionUpdate.createdSection(rawSectionIndex: rawSection)
        } else {
            //else we have added rows
            let insertedRows = TableDataContainerUpdate.inserted(
                indexPaths: items.mapIndex(generator: { (_, index) -> IndexPath in
                    return IndexPath(row: prevSize + index, section: rawSection)
                }))
            return TableDataSectionUpdate.updatedSection(updatedRows: insertedRows)
        }
    }

    public func removeItemsIn(section: Int) -> TableDataSectionUpdate {
        guard let rawIndex = sections.rawIndexOf(forIndex: section) else {
            return TableDataSectionUpdate.empty
        }
        _ = sections.remove(forIndex: section)
        return TableDataSectionUpdate.deletedSection(rawSectionIndex: rawIndex)
    }

    public func removeItem(atRow: Int, forSection: Int) -> TableDataSectionUpdate {
        var isEmptyAfterDelete = false

        guard let rawSection = updateSection(forSection: forSection, updateFunction: { content in
            _ = content.remove(at: atRow)
            isEmptyAfterDelete = content.isEmpty
        }) else {
            return TableDataSectionUpdate.empty
        }

        if isEmptyAfterDelete {
            return TableDataSectionUpdate.deletedSection(rawSectionIndex: rawSection)
        } else {
            return TableDataSectionUpdate.updatedSection(updatedRows:
                TableDataContainerUpdate.deleted(indexPaths: [IndexPath(row: atRow, section: rawSection)]))
        }
    }

    public func clearItems() -> TableDataSectionUpdate {
        sections.removeAll()
        return TableDataSectionUpdate.empty // TODO make me..
    }

    // MARK: section modifiers
    public func clear() -> TableDataSectionUpdate {
        let result = clearItems()
        clearHeaders()
        return result
    }

    /**
     * removes the given section (iff there) and returns the optional raw section index
     */
    public func remove(section: Int) -> TableDataSectionUpdate {
        removeHeader(forSection: section)
        return removeItemsIn(section: section)
    }

    /**
     * Overwrites a section with the given content
     * if the content is empty, the section is removed.
     * if the section did not exists, then the section is created
     */
    public func setSection(items: [GenericTableItem], forSection: Int) -> TableDataSectionUpdate {
        if items.isEmpty {
            //we are going to remove the section.
            return removeItemsIn(section: forSection)
        }
        let oldSectionContent = sections.getWithRawIndex(forIndex: forSection) ?? (TableDataSection(), -1)
        if oldSectionContent.item.isEmpty {
            //we added a new section
            return add(items: items, forSection: forSection)
        }
        //we have "overlap". compute diff.
        let diff = computeDiff(newItems: items, oldItems: oldSectionContent.item.data, forSection: oldSectionContent.rawIndex)
        setNewSectionContent(data: items, forSection: forSection )
        return TableDataSectionUpdate.updatedSection(updatedRows: diff)
    }

    private func computeDiff(newItems: [GenericTableItem],
                             oldItems: [GenericTableItem],
                             forSection: Int) -> TableDataContainerUpdate {
        //compute updated
        let updatedCount = min(newItems.count, oldItems.count)
        let updated: [IndexPath] = updatedCount.mapTimes { index -> IndexPath in
            IndexPath(row: index, section: forSection)
        }
        //calculate inserted (if any)
        let inserted: [IndexPath] = (newItems.count - oldItems.count)
            .mapTimes(generator: { (counter) -> IndexPath in
                IndexPath(row: updatedCount + counter, section: forSection)
            })
        //calculate deleted (if any)
        let deleted: [IndexPath] = (oldItems.count - newItems.count)
            .mapTimes(generator: { (counter) -> IndexPath in
                IndexPath(row: updatedCount + counter, section: forSection)
            })
        return TableDataContainerUpdate(inserted: inserted,
                                        updated: updated,
                                        removed: deleted)
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

    public func rowsInSection(forSection: Int) -> [GenericTableItem]? {
        return sections.get(forIndex: forSection)?.data
    }

    public func setSectionVisibility(forSection: Int, visible: Bool) -> TableDataSectionUpdate {
        //step 1 if equal then bail.
        guard let section = sections.get(forRawIndex: forSection) else {
            return TableDataSectionUpdate.empty
        }
        //if equal, then do nothing.
        if section.isHidden == !visible {
            return TableDataSectionUpdate.empty
        }
        section.isHidden = !visible
        //compute the raw index of the update.
        if visible {
            //we are adding this section.
            //and we have an update
            return TableDataSectionUpdate.createdSection(rawSectionIndex: 0)
        } else {
            //we are removing this section.
            //and we have an update
            return TableDataSectionUpdate.deletedSection(rawSectionIndex: 0)
        }
    }

    private func findRawIndexNotHidden() -> Int? {
        var unHiddenCounter = 0
        for counter in 0 ... sections.count - 1 {
            guard let section = sections.get(forRawIndex: counter) else {
                return nil
            }
            // if have found then return unHiddenCounter
            if section.isHidden == false {
                unHiddenCounter += 1
            }
        }
        return nil
    }

    // MARK: rendering and indexing - for items in sections

    private func getBadTableViewCell(tableView: UITableView, at: IndexPath) -> UITableViewCell {
        Logger.shared.logWarning(message: "Bad cell tried to be render at indexPath:\(at)")

        if shouldCrashOnBadCell {
            fatalError("Crashing on bad ui cell, the cell you tried to display was broken;" +
                    " indexPath is: \(at)")
        }
        return optionalBadCellRender?(tableView) ?? UITableViewCell()
    }

    private func updateSection(forSection: Int, updateFunction: MutatingFunction<[GenericTableItem]>) -> Int? {
        let input = sections.getWithRawIndex(forIndex: forSection)
        var temp = input?.item.data ?? []
        updateFunction(&temp)
        setNewSectionContent(data: temp, forSection: forSection)
        return input?.rawIndex ?? getRawSection(forSection: forSection)
    }

    private func setNewSectionContent(data: [GenericTableItem],
                                      forSection: Int) {
        if let old = sections.get(forIndex: forSection) {
            sections.set(value: old.updateContentWith(data), forIndex: forSection)
        } else {
            sections.set(value: TableDataSection(data: data, isHidden: false), forIndex: forSection)
        }
    }

    private func getSectionRowByIndex(at: IndexPath) -> GenericTableItem? {
        return sections.get(forRawIndex: at.section)?.data[at.row]
    }

    private func getSectionByIndex(index: Int) -> [GenericTableItem] {
        return sections.get(forRawIndex: index)?.data ?? []
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
