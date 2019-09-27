//
//  DynamicValueSet.swift
//  CollectionNxN
//
//  Created by Karthikeyan A. on 24/09/19.
//  Copyright © 2019 Aravind. All rights reserved.
//
import Foundation

typealias CompletionHandler = (() -> Void)

class DynamicValueSet<T> {
    //initial loaded array
    var value : T {
        didSet {
            self.notify()
        }
    }
    // get the final touch
    var finalPath : T {
        didSet {
            self.notify()
        }
    }
    
    // for identify the row and column
    var twoDimensionArray : [T] {
        didSet {
            self.notify()
        }
    }
    //get the count of row and columns
    var collectionCount : T {
        didSet {
            self.notify()
        }
    }
    
    private var observers = [String: CompletionHandler]()
    
    init(_ value: T, _ finalPath: T, _ twoDimensionArray : [T], _ collectionCount: T) {
        self.value = value
        self.finalPath = finalPath
        self.twoDimensionArray = twoDimensionArray
        self.collectionCount = collectionCount
    } 
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping CompletionHandler) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    private func notify() {
        observers.forEach({ $0.value() })
    }
    
    deinit {
        observers.removeAll()
    }
}

