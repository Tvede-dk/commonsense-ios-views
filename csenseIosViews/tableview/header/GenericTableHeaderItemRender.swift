//
//  GenericTableHeaderItemRender.swift
//  csenseIosViews
//
//  Created by Kasper T on 08/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import csenseSwift
import Foundation
import UIKit

open class GenericTableHeaderItemRender: GenericTableHeaderItem {

    public init( titleFunction: EmptyFunctionResult<String?>?,
                 viewFunction: EmptyFunctionResult<UIView?>?,
                 rowHeightFunction: EmptyFunctionResult<CGFloat?>? = nil,
                 estimatedRowHeightFunction: EmptyFunctionResult<CGFloat?>? = nil ) {
        self.estimatedRowHeightFunction = estimatedRowHeightFunction
        self.rowHeightFunction = rowHeightFunction
        self.getTitleFunction = titleFunction
        self.getViewFunction = viewFunction
    }

    private let getTitleFunction: EmptyFunctionResult<String?>?
    private let getViewFunction: EmptyFunctionResult<UIView?>?
    private let estimatedRowHeightFunction: EmptyFunctionResult<CGFloat?>?
    private let rowHeightFunction: EmptyFunctionResult<CGFloat?>?

    public func getHeaderHeight() -> CGFloat? {
        return rowHeightFunction?()
    }

    public func getHeaderView() -> UIView? {
        return getViewFunction?()
    }

    public func getEstimatedHeightForHeader() -> CGFloat? {
        return estimatedRowHeightFunction?()
    }

    public func getTitleForHeader() -> String? {
        return getTitleFunction?()
    }
}
