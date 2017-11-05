//
//  TableDataContainer.swift
//  csenseIosViews
//
//  Created by Kasper T on 04/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift

public class TableDataContainer: NSObject,
        UITableViewDelegate,
        UITableViewDataSource {


    private var sections: OrderedDictionary<Int,[GenericTableItem]> = OrderedDictionary()

    public func addData(item: GenericTableItem, inSection: Int) {
        sections.addOrCreate(key: inSection, item: item)
    }

    public func clearSection(sectionIndex: Int) {
        sections.removeValue(forKey: sectionIndex)
    }


    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSectionByIndex(index: section).count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return renderItem(tableView: tableView, at: indexPath)
    }

    private func getBadTableViewCell() -> UITableViewCell {
        //TODO log this, and or be able to configure this into a crash.
        return UITableViewCell()
    }


    private func getSectionRowByIndex(at: IndexPath) -> GenericTableItem?  {
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

    func renderFor<T>(cell: T) where T: UITableViewCell
}
