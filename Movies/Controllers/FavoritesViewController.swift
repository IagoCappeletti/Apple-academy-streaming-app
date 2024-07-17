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
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    // Services
    var favoriteService = FavoriteService.shared
    
    // Search
    private let searchController = UISearchController()
    private var movies: [Movie] = []
    private var series: [Serie] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    
//    @IBOutlet weak var ButtonSerie: UICommand!
//    @IBOutlet weak var ButtonMovies: UICommand!
    
    
//    @IBAction func buttonOrdenacao(_ sender: UIBarButtonItem) {
//
//        if((ButtonSerie) != nil){
//            print("teste serie")
//        }
//        else{
//            print("teste movie")
//        }
//
//
//    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movies = favoriteService.listAll()
        series = favoriteService.listAllSerie()
        tableView.reloadData()
    }
    
    
    
    
    private func setupViewController() {
        setupSearchController()
        setupTableView()
        setupRightBarButtonItem()
    }
    
    private func setupRightBarButtonItem() {
        let barButtonMenu = UIMenu(
            title: "",
            children: [
                UIAction(title: "Filmes", handler: { action in
                    print(action)
                    self.movies = self.favoriteService.listAll()
                }),
                UIAction(title: "Séries", handler: { action in
                    self.series = self.favoriteService.listAllSerie()
                })
            ])
        
        rightBarButtonItem.menu = barButtonMenu
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Pesquisar"
        navigationItem.searchController = searchController
    }
    

    private func setupTableView() {
        let nibMovie = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tableView.register(nibMovie, forCellReuseIdentifier: MovieTableViewCell.identifier)
        let nibSerie = UINib(nibName: "SerieTableViewCell", bundle: nil)
        tableView.register(nibSerie, forCellReuseIdentifier: SerieTableViewCell.identifier)
        tableView.dataSource = self
    }
    
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if section == 0 {
               return movies.count
           } else {
               return series.count
           }
       }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
                            return UITableViewCell()
                        }
            let movie = movies[indexPath.row]
            
                    cell.delegate = self
                    cell.setup(movie: movie)
                    return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SerieTableViewCell.identifier, for: indexPath) as? SerieTableViewCell else {
                return UITableViewCell()
            }

            let serie = series[indexPath.row]

            cell.delegate = self
            cell.setup(serie: serie)
            return cell
        }
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

extension FavoritesViewController: SerieTableViewCellDelegate {
    func didTapFavoriteButton(forSerie serie: Serie) {
        series.removeAll(where: { $0 == serie })
        favoriteService.removeSerie(withId: serie.id)
        tableView.reloadData()
        
    }
}
// MARK: - UISearchResultsUpdating

extension FavoritesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            movies = favoriteService.listAll()
           series = favoriteService.listAllSerie()
        } else {
            movies = filteredMovies(byTitle: searchText)
            series = filteredSeries(byTitle: searchText)
        }
        
        tableView.reloadData()
    }
    
    private func filteredSeries(byTitle serieTitle: String) -> [Serie] {
        favoriteService.listAllSerie().filter({ serie in
            serie.title.contains(serieTitle)
        })
    }
    
    
    private func filteredMovies(byTitle movieTitle: String) -> [Movie] {
        favoriteService.listAll().filter({ movie in
            movie.title.contains(movieTitle)
        })
    }
    
}
    
    
    
    
    

    

