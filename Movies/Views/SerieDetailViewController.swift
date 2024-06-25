//
//  SerieDetailViewController.swift
//  Series
//
//  Created by ios-noite-07 on 20/06/24.
//

import UIKit

class SerieDetailViewController: UIViewController {

    
    @IBOutlet weak var serieFavoriteButton: UIBarButtonItem!
    @IBOutlet var serieTitleLabel: UILabel!
    @IBOutlet var serieImageView: UIImageView!
    @IBOutlet var serieGenreLabel: UILabel!
    @IBOutlet var serieCountryLabel: UILabel!
    @IBOutlet var serieReleasedLabel: UILabel!
    @IBOutlet var serieLanguageLabel: UILabel!
    @IBOutlet var seriePlotLabel: UILabel!
    
    // Services
    var serieService = SerieService()
    var favoriteService = FavoriteService.shared
    
    // Data
    var serieId: String?
    var serieTitle: String?
    private var serie: Serie?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serieTitleLabel.text = serieTitle
        loadSerieData()
    }
    
    private func loadSerieData() {
        guard let serieId = serieId else { return }
        
        serieService.searchSerie(withId: serieId) { serie in
            
            self.serie = serie
            
            // Load movie image
            if let posterURL = serie?.posterURL {
                self.serieService.loadImageData(fromURL: posterURL) { imageData in
                    self.updateSerieImage(withImageData: imageData)
                }
            }
            
            DispatchQueue.main.async {
                self.updateViewData()
            }
        }
    }
    
    private func updateViewData() {
        serieGenreLabel.text = serie?.genre
        serieCountryLabel.text = serie?.country
        serieLanguageLabel.text = serie?.language
        serieReleasedLabel.text = serie?.released
        seriePlotLabel.text = serie?.plot
//        updateFavoriteButton()
    }
    
//    private func updateFavoriteButton() {
//        guard let serie = serie else { return }
//
//        let isFavorite = favoriteService.isFavorite(serieId: serie.id)
//        self.serie?.isFavorite = isFavorite
//        let favoriteIcon = isFavorite ? "heart.fill" : "heart"
//        serieFavoriteButton.image = .init(systemName: favoriteIcon)
//    }
    
    private func updateSerieImage(withImageData imageData: Data?) {
        guard let imageData = imageData else { return }
        
        DispatchQueue.main.async {
            let serieImage = UIImage(data: imageData)
            self.serieImageView.image = serieImage
        }
    }
    
//    @IBAction func didTapFavoriteButton(_ sender: Any) {
//        guard serie != nil else { return }

//        if serie.isFavorite {
            // Remove movie from favorite list
//            favoriteService.removeSerie(withId: serie.id)
//        } else {
//            // Add movie to favorite list
//            favoriteService.addSerie(serie)
//        }

//        updateFavoriteButton()
//    }
    
    
    
}
