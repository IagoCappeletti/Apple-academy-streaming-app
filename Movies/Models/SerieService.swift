//
//  SerieService.swift
//  Movies
//
//  Created by ios-noite-6 on 05/07/24.
//

import Foundation

struct SerieService {
    
    private let apiBaseURL = "https://www.omdbapi.com/?apikey="
    private let apiToken = "fad9f001"
    private let serieURL =  "&type=series"
    
    private var apiURL: String {
        apiBaseURL + apiToken + serieURL
    }
    
    private let decoder = JSONDecoder()
    
    func searchSeriesTitle(withTitle title: String, completion: @escaping ([Serie]?) -> Void) {
        let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = apiURL + "&s=\(query)"
        
        guard let url = URL(string: endpoint) else {
            completion([])
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if data == nil &&
                response == nil {
                completion(nil)
                return
            }
            
            guard let data = data,
                    error == nil else {
                completion([])
                return
            }
            
            do {
                let serieResponse = try decoder.decode(SerieSearchResponse.self, from: data)
                let series = serieResponse.search
                completion(series)
            } catch {
                print("FETCH ALL SERIES ERROR:TITLEEEEEEEEEEEEEEEEEEE \(error)")
                completion([])
            }
        }
        
        task.resume()
    }
    
    func searchSerieId(withId serieId: String, completion: @escaping (Serie?) -> Void) {
        let query = serieId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
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
                let serie = try decoder.decode(Serie.self, from: data)
                completion(serie)
            } catch {
                print("FETCH SERIE ERROR: \(error)")
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
