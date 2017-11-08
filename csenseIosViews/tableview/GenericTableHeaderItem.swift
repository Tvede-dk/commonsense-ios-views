//
//  GenericTableHeaderItem.swift
//  csenseIosViews
//
//  Created by Kasper T on 08/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation

public protocol GenericTableHeaderItem {
    func getHeaderHeight() -> CGFloat?
    func getHeaderView() -> UIView?
    func getEstimatedHeightForHeader() -> CGFloat?
    func getTitleForHeader() -> String?
}
