//
//  SerieCollectionViewCell.swift
//  Movies
//
//  Created by ios-noite-07 on 18/06/24.
//

import UIKit

class SerieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "movieCollectionCell"
    
    // Outlets
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieTitleLabel: UILabel!
    
    private let serieService = SerieService()
    
    func setup(serie: Serie) {
        serieImageView.layer.masksToBounds = true
        serieImageView.layer.cornerRadius = 8
        serieImageView.layer.borderWidth = 1
        serieImageView.layer.borderColor = UIColor.black.cgColor
        
        // Clean data
        serieImageView.image = nil
        serieTitleLabel.text = nil
        
        // Load movie poster from URL
        if let posterURL = serie.posterURL {
            serieService.loadImageData(fromURL: posterURL) { imageData in
                self.updateCell(withImageData: imageData, orTitle: serie.title)
            }
        }
    }
    
    private func updateCell(withImageData imageData: Data?, orTitle title: String) {
        DispatchQueue.main.async {
            if let imageData = imageData {
                // Show movie image
                let serieImage = UIImage(data: imageData)
                self.serieImageView.image = serieImage
            } else {
                // Show movie title if poster is not available
                self.serieTitleLabel.text = title
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        serieImageView.image = nil
        serieTitleLabel.text = nil
    }
}
