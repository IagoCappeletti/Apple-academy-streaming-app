//
//  MovieListViewController.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class MovieListViewController: UIViewController {

    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewEstadoVazio: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelEstadoVazio: UILabel!
    
    // Services
    var movieService = MovieService()
    
//    private var titleList : [String] = ["Piratas", "Steve Jobs", ]
    
    // Search
    private let searchController = UISearchController()
    private let defaultSearchName = "Steve Jobs"
    private var movies: [Movie] = []
    private let segueIdentifier = "showMovieDetailVC"
    
    // Collection item parameters
    private let itemsPerRow = 2.0
    private let spaceBetweenItems = 6.0
    private let itemAspectRatio = 1.5
    private let marginSize = 32.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        loadMovies(withTitle: defaultSearchName)
    }
    
    private func setupViewController() {
        setupSearchController()
        setupCollectionView()
    }
    
    public func hiddenView(bool: Bool){
        self.viewEstadoVazio.isHidden = bool
    }
    
    public func hiddenCollectioView(bool: Bool){
        
        self.collectionView.isHidden = bool
        
    }
    
    private func semConexaoAPI(){
        
            if let image = UIImage(systemName: "wifi.slash") {
                self.imageView.image = image
        }
            self.labelEstadoVazio.text = "Sem Conexao"
    }
    
    
    
    private func loadMovies(withTitle movieTitle: String) {
        movieService.searchMovies(withTitle: movieTitle) { movies in
//            DispatchQueue.main.async {
//                self.hiddenView(bool: !movies.isEmpty)
//                self.labelEstadoVazio.text = "Filme " + searchTextMovie + " não foi encontrado"
//                self.movies = movies
//                self.collectionView.reloadData()
//            }
            
            DispatchQueue.main.async { [self] in

                guard let movies = movies else {
                    // SEM INTERNET
                    self.semConexaoAPI()
                    self.hiddenCollectioView(bool: true)
                    self.hiddenView(bool: false)
                    return
                }
                // if movies.isEmpty { // Não tem a série pro título serieTitle }
                if(movies.isEmpty){
                    self.hiddenCollectioView(bool: true)
                    self.hiddenView(bool: false)
                    self.labelEstadoVazio.text = "Filmera " + searchTextMovie + " não foi encontrado"
                }else{
                    // else { // Existe séries para serem apresentadas }
                    self.hiddenCollectioView(bool: false)
                    self.hiddenView(bool: true)
                    self.movies = movies
                    self.collectionView.reloadData()
                }
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
        collectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieDetailVC = segue.destination as? MovieDetailViewController,
              let movie = sender as? Movie else {
            return
        }
        
        movieDetailVC.movieId = movie.id
        movieDetailVC.movieTitle = movie.title
    }
}

// MARK: - UICollectionViewDataSource

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.setup(movie: movie)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
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

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: selectedMovie)
    }
}

// MARK: - UISearchResultsUpdating
var searchTextMovie = ""
extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchTextMovie = searchController.searchBar.text ?? ""
        
        if searchTextMovie.isEmpty {
            loadMovies(withTitle: defaultSearchName)
        } else {
            loadMovies(withTitle: searchTextMovie)
        }
        
        collectionView.reloadData()
    }
}
