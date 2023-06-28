//
//  MoviesTableViewController.swift
//  TMDB-WA-101
//
//  Created by Michael Vorontsov on 24/05/2023.
//

import UIKit

class MVVMController: UITableViewController, MoviesListViewModelDelegate {
   
    
    
    var viewModel: MoviesListViewModel = .init(
        dataController: FallbackDataController()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewReady()
    }


    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        guard indexPath.item < viewModel.movies.count else { return cell}
        
        let movieViewModel = viewModel.movies[indexPath.item]
        
        cell.configure(with: movieViewModel)
        
        return cell
    }
    
    // MARK: MoviesListViewModelDelegate
    
    func moviesDidLoad(_ movies: [MovieViewModel]) {
        Task {
            tableView.reloadData()
        }
    }
    
    
}


extension UITableViewCell {
    
    func configure(with viewModel: MovieViewModel) {
        var config = defaultContentConfiguration()
        config.text = viewModel.title
        if let poster = viewModel.poster {
            config.image = poster
        }
        
        contentConfiguration = config
        
        viewModel.delegate = self
        viewModel.viewReady()
    }
}


extension UITableViewCell: MovieViewModelDelegate {
    func imageDidLoad(_ image: UIImage) {
        Task {
            guard var config = self.contentConfiguration as? UIListContentConfiguration else { return }
            
            config.image = image
            
            contentConfiguration = config
        }
    }
}
