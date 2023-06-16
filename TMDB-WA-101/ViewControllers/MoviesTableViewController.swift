//
//  MoviesTableViewController.swift
//  TMDB-WA-101
//
//  Created by Michael Vorontsov on 24/05/2023.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    var movies: [Movie] = []

    let dataController = FallbackDataController()
    lazy var moviesNavigationController: MoviesNavigationController = {
        MoviesNavigationController(
            navigationController: self.navigationController!,
            storyboard: self.storyboard!
        )
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let detailsViewController = segue.destination as? DetailsViewController,
            let sender = sender as? UITableViewCell,
            let index = tableView.indexPath(for: sender)?.item,
            movies.count > index
        else {
            return
        }
        
        let selectedMovie = movies[index]
        
        detailsViewController.movie = selectedMovie
    }

    func makeDetailsViewController(for movie: Movie) -> DetailsViewController? {
        let storyboard = self.storyboard
        
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as? DetailsViewController
        detailsViewController?.movie = movie
        
        return detailsViewController
    }
    
    @IBAction func demostrateSetView(_ sender: Any) {
        
        let viewControllers = movies.compactMap {
            self.makeDetailsViewController(for: $0)
        }
        
        self.navigationController?.setViewControllers([self] + viewControllers, animated: true)
        
    }
    
    @IBAction func demostratePush(_ sender: Any) {
        guard
            let movie = movies.randomElement()
        else { return }
  
        moviesNavigationController.showDetails(for: movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    private func loadData() {
        Task.init {
            do {
                self.movies += try await dataController.loadData(page: 1)
                self.tableView.reloadData()
            } catch {
                print("Error\(error)")
            }
        }

    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        guard indexPath.item < movies.count else { return cell}
        
        let movie = movies[indexPath.item]
        
        var config = cell.defaultContentConfiguration()
        config.text = movie.title
        
        cell.contentConfiguration = config
        
        return cell
    }
    
}
