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
        var result : GenericTableItem? = nil
        updateSection(inSection: inSection, updateFunction: { content in
            result = content.remove(at: atRow)
        })
        return result
    }

    public func removeAll() {

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
}

open class GenericTableItemRender<T>: GenericTableItem where T: UITableViewCell {

    public init(reuseIdentifier: String,
                nibName: String,
                bundle: Bundle? = nil,
                renderFunction: @escaping  Function<T>) throws {

        if nibName.isBlank {
            throw NSError(domain: "", code: 0)
        }

        self.reuseIdentifier = reuseIdentifier
        self.nibName = nibName
        self.bundle = bundle
        self.renderFunction = renderFunction
    }

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
        guard let tCell = cell as? T else {
            return
        }
        renderFor(cell: tCell)
    }

    /**
     *
     */
    public func renderFor(cell: T) {
        renderFunction(cell)
    }

}
