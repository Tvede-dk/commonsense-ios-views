//
// Created by Kasper T on 06/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation


public typealias Function<T> = (T) -> Void

public typealias MutatingFunction<T> = (inout T) -> Void

public typealias FunctionResult<T, U> = (T) -> U

public typealias EmptyFunctionResult<U> = () -> U

public typealias EmptyFunction = () -> Void
