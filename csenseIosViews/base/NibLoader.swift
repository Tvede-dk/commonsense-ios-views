//
//  NibLoader.swift
//  csenseIosViews
//
//  Created by Kasper T on 25/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift
public class NibLoader {

    ///Guard variable handling the fact that awakeAfter calls down and that further trigers a 3 call down (calls are out of control). so we guard.
    private var didAwakeCallDown = false
    public func awakeAfter<T>(withNib: UINib, callerSelf: T ) -> T? where T: UIView {
        //Guard && handle if we are creating subrecursivly.
        if didAwakeCallDown ||  isCalledRecursive(type: T.self) {
            return callerSelf
        }
        //Guard
        didAwakeCallDown = true
        let resArray = withNib.instantiate(withOwner: nil, options: nil)
        //TODO attach constraints here.
        //or frame
        let toWorkWith = resArray.first as? T
        toWorkWith?.translatesAutoresizingMaskIntoConstraints  = false
        return toWorkWith
    }
}
