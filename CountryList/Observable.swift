//
//  Observable.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import Foundation

/**
 * helper class for binding of our view and view model.
 * class is initialized with the value we want to observe.
 * function bind that does the actual binding.
 * observer is our closure called when the value is set.
 */

class Observable<T> {
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    var observer: ((T) -> Void)?
    
    func bind(closure: @escaping (T) -> Void) {
        closure(value)
        observer = closure
    }
}
