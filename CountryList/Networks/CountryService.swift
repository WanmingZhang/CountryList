//
//  CountryService.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import Foundation

protocol CountryServiceProtocol {
    func getCountryList(completion: @escaping (Result<[Country], Error>) -> Void)
}

class CountryService: CountryServiceProtocol {
    private let countryListURL = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
    
    func getCountryList(completion: @escaping (Result<[Country], Error>) -> Void) {
        guard let url = URL(string: countryListURL) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let countryList = try decoder.decode([Country].self, from: data)
                    completion(.success(countryList))
                } catch let error {
                    completion(.failure(error))
                }
            }
 
        }.resume()
    }

}
