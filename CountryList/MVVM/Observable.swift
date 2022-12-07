//
//  Observable.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import Foundation

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
