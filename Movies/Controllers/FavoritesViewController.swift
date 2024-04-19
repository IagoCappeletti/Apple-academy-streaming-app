//
//  FavoritesViewController.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Services
    var favoriteService = FavoriteService.shared
    
    // Search
    private let searchController = UISearchController()
    private var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movies = favoriteService.listAll()
        tableView.reloadData()
    }
    
    private func setupViewController() {
        setupSearchController()
        setupTableView()
        movies = favoriteService.listAll()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Pesquisar"
        navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        
        cell.delegate = self
        cell.setup(movie: movie)
        return cell
    }
}

// MARK: - MovieTableViewCellDelegate

extension FavoritesViewController: MovieTableViewCellDelegate {
    func didTapFavoriteButton(forMovie movie: Movie) {
        movies.removeAll(where: { $0 == movie })
        favoriteService.removeMovie(withId: movie.id)
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating

extension FavoritesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            movies = favoriteService.listAll()
        } else {
            movies = filteredMovies(byTitle: searchText)
        }
        
        tableView.reloadData()
    }
    
    private func filteredMovies(byTitle movieTitle: String) -> [Movie] {
        favoriteService.listAll().filter({ movie in
            movie.title.contains(movieTitle)
        })
    }
}
