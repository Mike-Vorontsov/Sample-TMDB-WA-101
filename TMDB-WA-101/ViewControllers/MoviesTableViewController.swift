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
        
        detailsViewController.parentController = self
        detailsViewController.movie = selectedMovie
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//
//        guard
//            let sender = sender as? UITableViewCell,
//            let index = tableView.indexPath(for: sender)?.item,
//            movies.count > index
//        else {
//            return false
//        }
//
//        let selectedMovie = movies[index]
//
//        return selectedMovie.title.count > 10 ? true : false
//
//    }
    
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
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            let cell = self.tableView.visibleCells.last
//            self.performSegue(withIdentifier: "showDetails", sender: cell)
//        }
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

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
        
        
//        if  indexPath.row == movies.count - 1 {
//            loadData()
//        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
