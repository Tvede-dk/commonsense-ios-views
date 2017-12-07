//
// Created by Kasper T on 29/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation

public extension UITableView {

    // MARK: GenericTableItem
    public func dequeueReusableCell(render: GenericTableItem,
                                    indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: render.getReuseIdentifier(), for: indexPath)
    }

    public func dequeueReusableCellAndRender(render: GenericTableItem,
                                             indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(render: render, indexPath: indexPath)
        render.renderFor(cell: cell)
        return cell
    }

}
