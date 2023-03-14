//
//  CountryListViewModel.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import Foundation
import Combine
/**
 * VIew model for CountryListViewController
 */

class CountryListViewModel {
    var apiManager: CountryServiceProtocol
    
    // Combine
    var subscriptions = Set<AnyCancellable>()
    var countries = CurrentValueSubject<[Country], Never>([Country]())
    
    // pass in a protocol type instead of the concrete type, which makes the code flexible and easy to test.
    init(_ apiManager: CountryServiceProtocol) {
        self.apiManager = apiManager
    }
    
    func fetchCountryList() {
        let publisher = apiManager.getCountries()
        
        publisher.sink { $0
            print("error getting countries list \($0)")
        } receiveValue: { [weak self] countries in
            self?.countries.send(countries)
        }.store(in: &subscriptions)
    }
    
    // MARK: Observable
    /**
     var countries: Observable<[Country]> = Observable([])
     var errorMsg: Observable<String?> = Observable(nil)
     
     func getCountryList() {
         apiManager.getCountryList {[weak self] result in
             guard let self = self else { return }
             switch result {
             case .success(let countries):
                 self.countries.value = countries
             case .failure(let error):
                 self.errorMsg.value = error.localizedDescription
             }
         }
     }
     */

}
