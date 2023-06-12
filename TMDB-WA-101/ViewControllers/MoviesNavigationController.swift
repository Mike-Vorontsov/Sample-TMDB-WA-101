//
//  MoviesNavigationController.swift
//  TMDB-WA-101
//
//  Created by Mykhailo Vorontsov on 12/06/2023.
//

import UIKit

class MoviesNavigationController {
    internal init(navigationController: UINavigationController, storyboard: UIStoryboard) {
        self.navigationController = navigationController
        self.storyboard = storyboard
    }
    
    
    private let navigationController: UINavigationController
    private let storyboard: UIStoryboard
    
    func showDetails(for movie: Movie) {
        
        guard let detailsViewController = storyboard.instantiateViewController(withIdentifier: "detailsViewController") as? DetailsViewController else { return }
        
        detailsViewController.movie = movie

        navigationController.pushViewController(detailsViewController, animated: true)

    }
    
}
