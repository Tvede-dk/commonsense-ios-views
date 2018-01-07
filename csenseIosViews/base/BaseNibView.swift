//
//  BaseCustomView.swift
//  csenseIosViews
//
//  Created by Kasper T on 04/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import UIKit
import csenseSwift

@objc open class BaseNibView: UIView {

    private let nibLoader = NibLoader()

    open func getNib() -> UINib {
        return UINib(nibName: getNibName(), bundle: getNibBundle())
    }

    open func getNibName() -> String {
        return String(describing: type(of: self))
    }

    open func getNibBundle() -> Bundle? {
        return Bundle(for: type(of: self))
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        //nibLoader.prepareForInterfaceBuilder()
    }

    open override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        return nibLoader.awakeAfter(withNib: getNib(), callerSelf: self)
    }
}
