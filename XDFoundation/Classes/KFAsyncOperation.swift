//
//  AsyncOperation.swift
//  BuddyKindergarener
//
//  Created by Matt on 2018/11/13.
//  Copyright © 2018 Matt. All rights reserved.
//

import Foundation

public class KFAsyncOperation: Operation {

    private var _isFinished: Bool = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    private var _isExecuting: Bool = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }

    var executeBlock: (KFAsyncOperation) -> Void

    public override var isAsynchronous: Bool {
        return true
    }

    public override var isConcurrent: Bool {
        return true
    }

    public override var isFinished: Bool {
        return _isFinished
    }

    public override var isExecuting: Bool {
        return _isExecuting
    }

    public init(block: @escaping (KFAsyncOperation) -> Void) {
        executeBlock = block
        super.init()
    }

    public override func start() {
        if isCancelled {
            finish()
            return
        }
        _isExecuting = true
        executeBlock(self)
    }

    public func finish() {
        _isExecuting = false
        _isFinished = true
    }
}
