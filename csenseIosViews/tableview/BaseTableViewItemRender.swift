//
//  BaseTableViewItemRender.swift
//  csenseIosViews
//
//  Created by Kasper T on 06/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import csenseSwift
import Foundation
open class BaseTableViewItemRender<T : UITableViewCell> : GenericTableItemRender<T> {
    
    public init(reuseIdentifier: String, nibName: String, bundle: Bundle?) {
       super.init(reuseIdentifier: reuseIdentifier,
                   nibName: nibName,
                   renderFunction: methodPointer(obj:self, method : BaseTableViewItemRender<T>.onRender),
                   onTappedFunction: methodPointer(obj:self, method : BaseTableViewItemRender<T>.onTapped),
                   rowHeightFunction: methodPointer(obj:self, method : BaseTableViewItemRender<T>.onRowHeight),
                   estimatedRowHeightFunction: methodPointer(obj:self, method : BaseTableViewItemRender<T>.onEstimateRowHeight))
        
    }
    
    open func onTapped(){
        
    }
    
    open func onRender(cell : T){
        
    }
    
    open func onEstimateRowHeight() -> CGFloat?{
        return nil
    }
    
    open func onRowHeight()-> CGFloat?{
        return nil
    }
}
