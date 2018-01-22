//
// Created by Kasper T on 06/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift

public protocol GenericTableItem {
    /**
     *
     */
    func getNib() -> UINib
    /**
     *
     */
    func getReuseIdentifier() -> String
    /**
     *
     */
    func renderFor(cell: UITableViewCell)
    /**
     *
     */
    func onTappedCalled()
    /**
     *
     */
    func getEstimatedHeight() -> CGFloat?
    /**
     *
     */
    func getCustomHeight() -> CGFloat?
    /**
     * 
     */
    func setUpdateFunction(callback:@escaping Function<Bool>)
}
