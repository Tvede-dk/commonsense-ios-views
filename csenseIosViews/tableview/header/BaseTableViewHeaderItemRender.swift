//
//  BaseTableViewHeaderItemRender.swift
//  csenseIosViews
//
//  Created by Kasper T on 08/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift
import UIKit
open class BaseTableViewHeaderItemRender : GenericTableHeaderItem {
    
    public init(){
        
    }
    
    open func getHeaderHeight() -> CGFloat? {
        return nil
    }
    
    open func getHeaderView() -> UIView? {
        return nil
    }
    
    open func getEstimatedHeightForHeader() -> CGFloat? {
        return nil
    }
    
    open func getTitleForHeader() -> String? {
        return nil
    }
    
}
