//
//  SerieListViewController.swift
//  Movies
//
//  Created by ios-noite-6 on 04/07/24.
//

import UIKit

class SerieListViewController: UIViewController {
    
   
    @IBOutlet weak var serieCollectionView: UICollectionView!
    @IBOutlet weak var viewEstadoVazio: UIView!
    @IBOutlet weak var labelEstadoVazio: UILabel!
    
    var serieService = SerieService()
    
    private let searchController = UISearchController()
    private let defaultSearchName = "Friends"
    private var series: [Serie] = []
    private let segueIdentifier = "showSerieDetailVC"
    
    // Collection item parameters
    private let itemsPerRow = 2.0
    private let spaceBetweenItems = 6.0
    private let itemAspectRatio = 1.5
    private let marginSize = 32.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        loadSeries(withTitle: defaultSearchName)
    }
                   
    private func setupViewController() {
            setupSearchController()
            setupCollectionView()
    }
    
    public func hiddenView(bool: Bool){
        self.viewEstadoVazio.isHidden = bool
    }
     

    private func loadSeries(withTitle serieTitle: String) {
        serieService.searchSeriesTitle(withTitle: serieTitle) { series in
            DispatchQueue.main.async {
                self.hiddenView(bool: !series.isEmpty)
                self.labelEstadoVazio.text = "Série " + searchText + " não foi encontrada"
                self.series = series
                self.serieCollectionView.reloadData()
            }
        }
    }
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Pesquisar"
        navigationItem.searchController = searchController
    }
    
     func setupCollectionView() {
        let nib = UINib(nibName: "SerieCollectionViewCell", bundle: nil)
        serieCollectionView.register(nib, forCellWithReuseIdentifier: SerieCollectionViewCell.identifier)
        serieCollectionView.dataSource = self
        serieCollectionView.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let serieDetailVC = segue.destination as? SerieDetailViewController,
              let serie = sender as? Serie else {
            return
        }
        
        serieDetailVC.serieId = serie.id
        serieDetailVC.serieTitle = serie.title
    }

}

extension SerieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        series.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SerieCollectionViewCell.identifier, for: indexPath) as? SerieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let serie = series[indexPath.row]
        cell.setup(serie: serie)
        return cell
    }

}

extension SerieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionWidth = collectionView.frame.size.width - marginSize
        let availableWidth = collectionWidth - (spaceBetweenItems * itemsPerRow)
        
        let itemWidth = availableWidth / itemsPerRow
        let itemHeight = itemWidth * itemAspectRatio
        
        return .init(width: itemWidth, height: itemHeight)
    }
}

extension SerieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSerie = series[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: selectedSerie)
    }
}

// MARK: - UISearchResultsUpdating
var searchText = ""
extension SerieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
         searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            loadSeries(withTitle: defaultSearchName)
        } else {
            loadSeries(withTitle: searchText)
        }
        
        serieCollectionView.reloadData()
    }
}

