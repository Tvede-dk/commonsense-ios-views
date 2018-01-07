//
// Created by Kasper T on 20/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation

/**
 *
 *
 */
func isAnyNotNil(_ objects: Any?...) -> Bool {
    return objects.count == 0 || objects.contains { object in
        return object != nil
    }
}

/**
 *
 *
 */
func isAnyNil( _ objects : Any? ...) -> Bool{
    return objects.count > 0 && objects.contains(where: {object -> Bool in
        object == nil
    })
}
