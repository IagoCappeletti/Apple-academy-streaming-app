//
//  FavoriteServiceSerie.swift
//  Movies
//
//  Created by ios-noite-07 on 30/04/24.
//

import Foundation

class FavoriteServiceSerie {
    
    // Singleton instance
    static let shared = FavoriteServiceSerie()
    private init() {}
    
    // In memory data
    private var favoriteSerie: [Serie] = []
    
    func listAll() -> [Serie] {
        favoriteSerie
    }
    
    func isFavorite(serieId: String) -> Bool {
        favoriteSerie.contains { serie in
            serie.id == serieId
        }
    }
    
    func addSerie(_ serie: Serie) {
        favoriteSerie.append(serie)
    }
    
    func removeSerie(withId serieId: String) {
        favoriteSerie.removeAll { serie in
            serie.id == serieId
        }
    }
}
