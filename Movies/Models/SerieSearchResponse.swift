//
//  SerieSearchResponse.swift
//  Movies
//
//  Created by ios-noite-6 on 18/06/24.
//

import Foundation
struct SerieSearchResponse: Decodable {
    let search: [Serie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
