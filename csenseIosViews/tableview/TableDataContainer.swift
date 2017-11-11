//
//  TableDataContainer.swift
//  csenseIosViews
//
//  Created by Kasper T on 04/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
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

    private var headerSections: OrderedDictionary<Int, GenericTableHeaderItem> = OrderedDictionary()

    private var sections: OrderedDictionary<Int, [GenericTableItem]> = OrderedDictionary()

    // MARK: items modifiers
    public func add(item: GenericTableItem, forSection: Int) {
        sections.addOrCreate(key: forSection, item: item)
    }

    public func add(items: [GenericTableItem], forSection: Int) {
        sections.addOrCreate(key: forSection, items: items)
    }

    public func removeItemsIn(section: Int) -> [GenericTableItem] {
        return sections.removeValue(forKey: section) ?? []
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
        return headerSections.ElementByIndex(index: section)?.getTitleForHeader()
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerSections.ElementByIndex(index: section)?.getHeaderView()
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return headerSections.ElementByIndex(index: section)?.getEstimatedHeightForHeader()
                ?? UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerSections.ElementByIndex(index: section)?.getHeaderHeight() ?? 0
    }

    public func setHeader(_ header: GenericTableHeaderItem, forSection: Int) {
        headerSections.updateValue(header, forKey: forSection)
    }

    public func removeHeader(forSection: Int) {
        headerSections.index(forKey: forSection).useSafe { index in
            headerSections.remove(at: index)
        }
    }

    public func clearHeaders() {
        headerSections.removeAll()
    }

    // MARK: rendering and indexing - for items in sections

    private func getBadTableViewCell() -> UITableViewCell {
        //TODO log this, and or be able to configure this into a crash.
        return UITableViewCell()
    }

    private func updateSection(forSection: Int, updateFunction: MutatingFunction<[GenericTableItem]>) {
        var input = sections[forSection] ?? []
        updateFunction(&input)
        sections.updateValue(input, forKey: forSection)
    }

    private func getSectionRowByIndex(at: IndexPath) -> GenericTableItem? {
        return sections.ElementByIndex(index: at.section)?[at.row]
    }

    private func getSectionByIndex(index: Int) -> [GenericTableItem] {
        return sections.ElementByIndex(index: index) ?? []
    }

    private func renderItem(tableView: UITableView, at: IndexPath) -> UITableViewCell {
        let optItem = getSectionRowByIndex(at: at)
        guard let safeItem = optItem else {
            return getBadTableViewCell()
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
