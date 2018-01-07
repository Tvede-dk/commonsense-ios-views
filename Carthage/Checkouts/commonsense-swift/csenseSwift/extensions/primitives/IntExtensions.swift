//
// Created by Kasper T on 06/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation

public extension Int {
    /**
     * Computes the middle index given the upperBound (we are lower bound)
     * Eg the middle between 20 and 50 is 35.
     */
    public func middle(upperBound: Int) -> Int {
        return self + (upperBound - self) / 2
    }

    public var isNegative: Bool {
        return self < 0
    }

    public var isPositive: Bool {
        return self > 0
    }

    public var isZeroOrNegative: Bool {
        return self <= 0
    }

    public var isZeroOrPositive: Bool {
        return self >= 0
    }
}


public extension Optional where Wrapped == Int {
    /**
     *   the current value iff not nil otherwise 0
     */
    public var orZero: Int {
        return self ?? 0
    }
}
