//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var movieFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieCountryLabel: UILabel!
    @IBOutlet weak var movieReleasedLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var moviePlotLabel: UILabel!
    
    // Services
    var movieService = MovieService()
    var favoriteService = FavoriteService.shared
    
    // Data
    var movieId: String?
    var movieTitle: String?
    private var movie: Movie?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieTitleLabel.text = movieTitle
        loadMovieData()
    }
    
    private func loadMovieData() {
        guard let movieId = movieId else { return }
        
        movieService.searchMovie(withId: movieId) { movie in
            
            self.movie = movie
            
            // Load movie image
            if let posterURL = movie?.posterURL {
                self.movieService.loadImageData(fromURL: posterURL) { imageData in
                    self.updateMovieImage(withImageData: imageData)
                }
            }
            
            DispatchQueue.main.async {
                self.updateViewData()
            }
        }
    }
    
    private func updateViewData() {
        movieGenreLabel.text = movie?.genre
        movieCountryLabel.text = movie?.country
        movieLanguageLabel.text = movie?.language
        movieReleasedLabel.text = movie?.released
        moviePlotLabel.text = movie?.plot
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let movie = movie else { return }
        
        let isFavorite = favoriteService.isFavorite(movieId: movie.id)
        self.movie?.isFavorite = isFavorite
        let favoriteIcon = isFavorite ? "heart.fill" : "heart"
        movieFavoriteButton.image = .init(systemName: favoriteIcon)
    }
    
    private func updateMovieImage(withImageData imageData: Data?) {
        guard let imageData = imageData else { return }
        
        DispatchQueue.main.async {
            let movieImage = UIImage(data: imageData)
            self.movieImageView.image = movieImage
        }
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let movie = movie else { return }
        
        if movie.isFavorite {
            // Remove movie from favorite list
            favoriteService.removeMovie(withId: movie.id)
        } else {
            // Add movie to favorite list
            favoriteService.addMovie(movie)
        }
        
        updateFavoriteButton()
    }
}
