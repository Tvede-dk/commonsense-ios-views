//
//  FunctionExtensions.swift
//  csenseSwift
//
//  Created by Kasper T on 06/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation


/**
 Creates a safe method pointer for use in allocing closures.
 */
// see http://blog.xebia.com/function-references-in-swift-and-retain-cycles/
public func methodPointer<T: AnyObject>(obj: T,
                                        method: @escaping FunctionResult<T,EmptyFunction>)
    -> EmptyFunction {
        return { [weak obj] in
            guard let safeObj = obj else {
                return
            }
            method(safeObj)()
        }
}


public func methodPointer<T: AnyObject, In>(obj: T,
                                            method:
    @escaping FunctionResult<T,FunctionResult<In, Void>>)
    -> FunctionResult<In, Void> {
        return { [weak obj] inputValue in
            if let safeObj = obj{
                method(safeObj)(inputValue)
            }
        }
}

public func methodPointer<T: AnyObject, Out>(obj: T,
                                                             method:
    @escaping FunctionResult<T,EmptyFunctionResult<Out?>>)
    -> EmptyFunctionResult<Out?> {
        return { [weak obj]  in
            if let safeObj = obj{
                return method(safeObj)()
            }
            return nil
        }
}

/**
 Creates a safe method pointer for use in allocing closures.
 */
// see http://blog.xebia.com/function-references-in-swift-and-retain-cycles/
public func methodPointer<T: AnyObject, In, Out>(obj: T,
                                                 method:
    @escaping FunctionResult<T,FunctionResult<In, Out?>>)
    -> FunctionResult<In, Out?> {
        return { [weak obj] inputValue in
            if let safeObj = obj{
                return method(safeObj)(inputValue)
            }
            return nil
        }
}

