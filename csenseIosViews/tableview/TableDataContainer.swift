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


    private var sections: OrderedDictionary<Int, [GenericTableItem]> = OrderedDictionary()

    public func add(item: GenericTableItem, inSection: Int) {
        sections.addOrCreate(key: inSection, item: item)
    }

    public func add(items: [GenericTableItem], inSection: Int) {
        sections.addOrCreate(key: inSection, items: items)
    }

    public func remove(section: Int) -> [GenericTableItem] {
        return sections.removeValue(forKey: section) ?? []
    }

    public func remove(atRow: Int, inSection: Int) -> GenericTableItem? {
        var result: GenericTableItem? = nil
        updateSection(inSection: inSection, updateFunction: { content in
            result = content.remove(at: atRow)
        })
        return result
    }

    public func clear() {
        sections.removeAll()
    }


    //MARK: Table view implementations
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

    //MARK: rendering and indexing

    private func getBadTableViewCell() -> UITableViewCell {
        //TODO log this, and or be able to configure this into a crash.
        return UITableViewCell()
    }

    private func updateSection(inSection: Int, updateFunction: MutatingFunction<[GenericTableItem]>) {
        var input = sections[inSection] ?? []
        updateFunction(&input)
        sections.updateValue(input, forKey: inSection)
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
        return cell
    }
}

public protocol GenericTableItem {
    func getNib() -> UINib
    func getReuseIdentifier() -> String
    func renderFor(cell: UITableViewCell)
    func onTappedCalled()
    func getEstimatedHeight() -> CGFloat?
    func getCustomHeight() -> CGFloat?
}

open class GenericTableItemRender<T>: GenericTableItem where T: UITableViewCell {

    public init(reuseIdentifier: String,
                nibName: String,
                bundle: Bundle? = nil,
                renderFunction: @escaping Function<T>,
                onTappedFunction: EmptyFunction? = nil,
                estimatedRowHeightFunction: EmptyFunctionResult<CGFloat>? = nil,
                rowHeightFunction: EmptyFunctionResult<CGFloat>? = nil) throws {

        if nibName.isBlank {
            throw NSError(domain: "Bad nib name", code: -200)
        }

        self.reuseIdentifier = reuseIdentifier
        self.nibName = nibName
        self.bundle = bundle
        self.renderFunction = renderFunction
        self.onTappedFunction = onTappedFunction
        self.estimatedRowHeightFunction = estimatedRowHeightFunction
        self.rowHeightFunction = rowHeightFunction
    }

    private let estimatedRowHeightFunction: EmptyFunctionResult<CGFloat>?
    private let rowHeightFunction: EmptyFunctionResult<CGFloat>?

    private let onTappedFunction: EmptyFunction?
    private let reuseIdentifier: String

    private let nibName: String
    private let bundle: Bundle?

    private let renderFunction: (T) -> Void

    /**
     *
     */
    public func getNib() -> UINib {
        return UINib(nibName: nibName, bundle: bundle)
    }

    /**
     *
     */
    public func getReuseIdentifier() -> String {
        return reuseIdentifier
    }

    public func renderFor(cell: UITableViewCell) {

        safeUseCell(cell: cell, action: renderFunction)
    }


    public func onTappedCalled() {
        onTappedFunction?()
    }

    public func getEstimatedHeight() -> CGFloat? {
        return estimatedRowHeightFunction?()
    }

    public func getCustomHeight() -> CGFloat? {
        return rowHeightFunction?()
    }
    
    /**
     * Called from a given cell, tells us that we are to be updated. (we have changed)
     */
    public func update(){
        
    }

    /**
     *
     */
    public func renderFor(cell: T) {
        renderFunction(cell)
        lastCell = cell
    }

    private weak var lastCell : T? = nil
    
    //MARK: Helpers

    private func safeUseCell(cell: UITableViewCell, action: Function<T>?) {
        guard let tCell = cell as? T else {
            return
        }
        action?(tCell)
    }


}
