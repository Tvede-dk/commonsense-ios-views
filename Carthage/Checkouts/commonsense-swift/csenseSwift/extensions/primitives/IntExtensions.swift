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

    /**
     * If this number is negative (less than 0)
     */
    public var isNegative: Bool {
        return self < 0
    }

    /**
     * If this number is positive (greater than 0)
     */
    public var isPositive: Bool {
        return self > 0
    }

    /**
     * If this number is negative or 0 (less than or equal to 0)
     */
    public var isZeroOrNegative: Bool {
        return self <= 0
    }

    /**
     * If this number is positive or 0 (greater than or equal to 0)
     */
    public var isZeroOrPositive: Bool {
        return self >= 0
    }

    /**
     * If this number is 0 (equal to 0)
     */
    public var isZero: Bool {
        return self == 0
    }

    /**
     * Performs the times the value of this int, the given action.
     * so if the value is 2 then the action is performed 2 times.
     * if the value is negative or 0 nothing happens.
     * the value is passed to the action.
     */
    public func performTimes(fromValue: Int = 0,
                             action: Function<Int>) {
        if self.isZeroOrNegative || fromValue.isNegative {
            return
        }
        for counter in fromValue ... self - 1 {
            action(counter)
        }
    }

    /**
     * maps the number from (default 0) to this value.
     * the same as (fromValue ... self -1).map(generator)
     */
    public func mapTimes<T>(fromValue: Int = 0,
                            generator: FunctionResult<Int, T>) -> [T] {
        var result: [T] = []
        performTimes(fromValue: fromValue, action: { (value) in
            result += generator(value)
        })
        return result
    }
}

public extension Optional where Wrapped == Int {
    /**
     * The current value iff not nil otherwise 0
     */
    public var orZero: Int {
        return self ?? 0
    }
}
