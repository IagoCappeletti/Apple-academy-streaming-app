//
//  SerieDetailViewController.swift
//  Movies
//
//  Created by ios-noite-07 on 05/07/24.
//

import UIKit

class SerieDetailViewController: UIViewController {

   
    @IBOutlet weak var serieFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var serieGenreLabel: UILabel!
    @IBOutlet weak var serieCountryLabel: UILabel!
    @IBOutlet weak var serieLanguageLabel: UILabel!
    @IBOutlet weak var serieReleasedLabel: UILabel!
    @IBOutlet weak var serieTitleLabel: UILabel!
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var seriePlotLabel: UILabel!
    
    //Service
    var serieService = SerieService()
    
    //Dados
    var serieId: String?
    var serieTitle: String?
    private var serie: Serie?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serieTitleLabel.text = serieTitle
        loadSerieDataSerie()
    }
    private func loadSerieDataSerie() {
        guard let serieId = serieId else { return }
        
        serieService.searchSerieId(withId: serieId) { serie in
            
            self.serie = serie
            
            // Load serie image
            if let posterURL = serie?.posterURL {
                self.serieService.loadImageData(fromURL: posterURL) { imageData in
                    self.updateSerieImage(withImageData: imageData)
                }
            }
            
            DispatchQueue.main.async {
                self.updateViewDataSerie()
            }
        }
    }
    
    private func updateViewDataSerie(){
            serieGenreLabel.text = serie?.genre
            serieCountryLabel.text = serie?.country
            serieLanguageLabel.text = serie?.language
            serieReleasedLabel.text = serie?.released
            seriePlotLabel.text = serie?.plot
            //updateFavoriteButton()
        }
    
   // private func updateFavoriteButton(){
     //   guard let serie = serie else { return }
    
    //    let isFavorite = favoriteService.isFavorite(serieId: serie.id)
    //    self.serie?.isFavorite = isFavorite
    //    let favoriteIcon = isFavorite ? "heart.fill" : "heart"
    //    serieFavoriteButton.image = .init(systemName: favorite
   // }
    
    private func updateSerieImage(withImageData imageData: Data?) {
        guard let imageData = imageData else { return }
        
        DispatchQueue.main.async {
            let serieImage = UIImage(data: imageData)
            self.serieImageView.image = serieImage
        }
    }
    
    
    
}
