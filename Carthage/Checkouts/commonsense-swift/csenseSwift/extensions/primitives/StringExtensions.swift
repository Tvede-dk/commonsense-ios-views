//
// Created by Kasper T on 06/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation

public extension Optional where Wrapped == String {

    /**
     *Returns true iff the string is nil or if it is blank (only consisting of whitespace).
     */
    public var isNilOrBlank: Bool {
        return self?.isBlank != false
    }
}

public extension String {
    /**
     * returns true iff the string is not empty (contains something)
     */
    public var isNotEmpty: Bool {
        return !isEmpty
    }

    /**
     * tells if the string only contains whitespace characters, if not then this is false
     */
    public var isBlank: Bool {
        return self == "" || self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }

    /**
     * tells if the string does not only contains whitespace characters, if not then this is false
     */
    public var isNotBlank: Bool {
        return !isBlank
    }

    /**
     * Url encodes a string, such that it can be used as parameters (eg query strings ect).
     */
    public func urlEncoded() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }

}
