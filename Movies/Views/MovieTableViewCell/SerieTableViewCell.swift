//
//  SerieTableViewCell.swift
//  Movies
//
//  Created by ios-noite-07 on 05/07/24.
//

import UIKit

protocol SerieTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(forSerie serie: Serie)
}

class SerieTableViewCell: UITableViewCell {

    static let identifier = "serieTableCell"
    weak var delegate: SerieTableViewCellDelegate?
    
    // Outlets
    @IBOutlet weak var serieTitleLabel: UILabel!
    @IBOutlet weak var serieGenreLabel: UILabel!
    @IBOutlet weak var serieImageView: UIImageView!
    
    private let serieService = SerieService()
    
    // Data
    private var serie: Serie?
    
    func setup(serie: Serie) {
        self.serie = serie
        serieTitleLabel.text = serie.title
        serieGenreLabel.text = serie.genre ?? "Não definido"
        
        serieImageView.layer.masksToBounds = true
        serieImageView.layer.cornerRadius = 4
        serieImageView.layer.borderWidth = 1
        serieImageView.layer.borderColor = UIColor.black.cgColor
        
        // Load movie poster from URL
        if let posterURL = serie.posterURL {
            serieService.loadImageData(fromURL: posterURL) { imageData in
                DispatchQueue.main.async {
                    let serieImage = UIImage(data: imageData ?? Data())
                    self.serieImageView.image = serieImage
                }
            }
        }
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let serie = serie else { return }
        delegate?.didTapFavoriteButton(forSerie: serie)
        }
    }

