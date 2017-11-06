//
// Created by Kasper T on 06/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift

open class GenericTableItemRender<T>: GenericTableItem where T: UITableViewCell {

    public init(reuseIdentifier: String,
                nibName: String,
                bundle: Bundle? = nil,
                renderFunction: @escaping Function<T>,
                onTappedFunction: EmptyFunction? = nil,
                estimatedRowHeightFunction: EmptyFunctionResult<CGFloat?>? = nil,
                rowHeightFunction: EmptyFunctionResult<CGFloat?>? = nil) throws {

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

    private let estimatedRowHeightFunction: EmptyFunctionResult<CGFloat?>?
    private let rowHeightFunction: EmptyFunctionResult<CGFloat?>?

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
        updateFunction?()
    }

    public func setUpdateFunction(callback: @escaping EmptyFunction) {
        updateFunction = callback
    }
    private var updateFunction : EmptyFunction? = nil

    /**
     *
     */
    public func renderFor(cell: T) {
        renderFunction(cell)
    }

    //MARK: Helpers

    private func safeUseCell(cell: UITableViewCell, action: Function<T>?) {
        guard let tCell = cell as? T else {
            return
        }
        action?(tCell)
    }



}
