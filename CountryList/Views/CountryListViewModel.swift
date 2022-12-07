//
//  CountryListViewModel.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import Foundation

class CountryListViewModel {

    var apiManager: CountryServiceProtocol
    var countries: Observable<[Country]> = Observable([])
    var errorMsg: Observable<String?> = Observable(nil)
    
    init(_ apiManager: CountryServiceProtocol) {
        self.apiManager = apiManager
    }
    
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
}
