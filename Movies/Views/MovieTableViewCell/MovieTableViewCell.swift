//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

protocol MovieTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(forMovie movie: Movie)
}

class MovieTableViewCell: UITableViewCell {
    
    static let identifier = "movieTableCell"
    weak var delegate: MovieTableViewCellDelegate?
    
    // Outlets
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    private let movieService = MovieService()
    
    // Data
    private var movie: Movie?
    
    func setup(movie: Movie) {
        self.movie = movie
        movieTitleLabel.text = movie.title
        movieGenreLabel.text = movie.genre ?? "Não definido"
        
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 4
        movieImageView.layer.borderWidth = 1
        movieImageView.layer.borderColor = UIColor.black.cgColor
        
        // Load movie poster from URL
        if let posterURL = movie.posterURL {
            movieService.loadImageData(fromURL: posterURL) { imageData in
                DispatchQueue.main.async {
                    let movieImage = UIImage(data: imageData ?? Data())
                    self.movieImageView.image = movieImage
                }
            }
        }
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let movie = movie else { return }
        delegate?.didTapFavoriteButton(forMovie: movie)
    }
}
