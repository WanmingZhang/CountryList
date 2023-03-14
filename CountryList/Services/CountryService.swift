//
//  CountryService.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import Foundation
import Combine

protocol CountryServiceProtocol {
    // Observable
    func getCountryList(completion: @escaping (Result<[Country], Error>) -> Void)
    // Combine
    func getCountries() -> AnyPublisher<[Country], Error>
}

class CountryService: CountryServiceProtocol {
    private let countryListURL = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
    
  
    func getCountries() -> AnyPublisher<[Country], Error> {
        let url = URL(string: countryListURL)!
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 }
            .map { $0.data }
            .decode(type: [Country].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            
        return publisher
    }
    
    
    func getCountryList(completion: @escaping (Result<[Country], Error>) -> Void) {
        guard let url = URL(string: countryListURL) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                // handle error
                completion(.failure(error!))
                return
            }
            guard let response = response else {
                // handle error
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  case 200...299 = httpResponse.statusCode
            else {
                // handle error
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let countryList = try decoder.decode([Country].self, from: data)
                    completion(.success(countryList))
                } catch let error {
                    print("Fail to encode countries: \(error)")
                    completion(.failure(error))
                }
            }
 
        }.resume()
    }

}
