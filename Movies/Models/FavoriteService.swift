//
//  FavoriteService.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import Foundation

class FavoriteService {
    
    // Singleton instance
    static let shared = FavoriteService()
    private init() {}
    
    // In memory data
    private var favoriteMovies: [Movie] = []
    private var favoriteSeries: [Serie] = []
    
    
    
    func listAll() -> [Movie] {
        favoriteMovies
    }
    
    func isFavorite(movieId: String) -> Bool {
        favoriteMovies.contains { movie in
            movie.id == movieId
        }
    }
    
    func addMovie(_ movie: Movie) {
        favoriteMovies.append(movie)
    }
    
    func removeMovie(withId movieId: String) {
        favoriteMovies.removeAll { movie in
            movie.id == movieId
        }
    }
    
    //Series
    
    
    func listAllSerie() -> [Serie] {
        favoriteSeries
    }
    
    func isFavoriteSerie(serieId: String) -> Bool {
        favoriteSeries.contains { serie in
            serie.id == serieId
        }
    }
    
    func addSerie(_ serie: Serie) {
        favoriteSeries.append(serie)
    }
    
    func removeSerie(withId serieId: String) {
        favoriteSeries.removeAll { serie in
            serie.id == serieId
        }
    }
    
}
