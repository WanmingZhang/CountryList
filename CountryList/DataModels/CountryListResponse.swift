//
//  CountryResponse.swift
//  CountryList
//
//  Created by wanming zhang on 12/6/22.
//

import Foundation

/**
 * data models for country list json
 */

struct Country: Decodable {
    let capital: String
    let code: String
    let currency: Currency
    let flagUrl: String
    let language: Language
    let name: String
    let region: String
    
    enum CodingKeys: String, CodingKey {
        case capital = "capital"
        case code = "code"
        case currency = "currency"
        case flagUrl = "flag"
        case language = "language"
        case name = "name"
        case region = "region"
    }
}

struct Currency: Decodable {
    let code: String
    let name: String
    let symbol: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case name = "name"
        case symbol = "symbol"
    }
}

struct Language: Decodable {
    let code: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case name = "name"
    }
}
    
 
