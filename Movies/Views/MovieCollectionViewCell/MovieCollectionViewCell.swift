//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "movieCollectionCell"
    
    // Outlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    private let movieService = MovieService()
    
    func setup(movie: Movie) {
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 8
        movieImageView.layer.borderWidth = 1
        movieImageView.layer.borderColor = UIColor.black.cgColor
        
        // Clean data
        movieImageView.image = nil
        movieTitleLabel.text = nil
        
        // Load movie poster from URL
        if let posterURL = movie.posterURL {
            movieService.loadImageData(fromURL: posterURL) { imageData in
                self.updateCell(withImageData: imageData, orTitle: movie.title)
            }
        }
    }
    
    private func updateCell(withImageData imageData: Data?, orTitle title: String) {
        DispatchQueue.main.async {
            if let imageData = imageData {
                // Show movie image
                let movieImage = UIImage(data: imageData)
                self.movieImageView.image = movieImage
            } else {
                // Show movie title if poster is not available
                self.movieTitleLabel.text = title
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        movieTitleLabel.text = nil
    }
}
