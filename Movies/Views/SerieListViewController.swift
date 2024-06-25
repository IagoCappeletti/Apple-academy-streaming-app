//
//  SerieListViewController.swift
//  Movies
//
//  Created by ios-noite-07 on 20/06/24.
//

import UIKit

class SerieListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    // Services
    var serieService = SerieService()
    
    // Search
    private let searchController = UISearchController()
    private let defaultSearchName = "Steve Jobs"
    private var series: [Serie] = []
    private let segueIdentifier = "showMovieDetailVC"
    
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
    
    private func loadSeries(withTitle serieTitle: String) {
        serieService.searchSeries(withTitle: serieTitle) { series in
            DispatchQueue.main.async {
                self.series = series
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Pesquisar"
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: SerieCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
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

// MARK: - UICollectionViewDataSource

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

// MARK: - UICollectionViewDelegateFlowLayout

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

// MARK: - UICollectionViewDelegate

extension SerieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSerie = series[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: selectedSerie)
    }
}

// MARK: - UISearchResultsUpdating

extension SerieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            loadSeries(withTitle: defaultSearchName)
        } else {
            loadSeries(withTitle: searchText)
        }
        
        collectionView.reloadData()
    }
}

   

