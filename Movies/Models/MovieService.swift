//
//  MovieService.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import Foundation

struct MovieService {
    
    private let apiBaseURL = "https://www.omdbapi.com/?apikey="
    private let apiToken = "fad9f001"
    
    private var apiURL: String {
        apiBaseURL + apiToken
    }
    
    private let decoder = JSONDecoder()
    
    func searchMovies(withTitle title: String, completion: @escaping ([Movie]) -> Void) {
        let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = apiURL + "&s=\(query)"
        
        guard let url = URL(string: endpoint) else {
            completion([])
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                    error == nil else {
                completion([])
                return
            }
            
            do {
                let movieResponse = try decoder.decode(MovieSearchResponse.self, from: data)
                let movies = movieResponse.search
                completion(movies)
            } catch {
                print("FETCH ALL MOVIES ERROR: \(error)")
                completion([])
            }
        }
        
        task.resume()
    }
    
    func searchMovie(withId movieId: String, completion: @escaping (Movie?) -> Void) {
        let query = movieId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = apiURL + "&i=\(query)"
        
        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let movie = try decoder.decode(Movie.self, from: data)
                completion(movie)
            } catch {
                print("FETCH MOVIE ERROR: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func loadImageData(fromURL link: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data)
        }
        
        task.resume()
    }
}
