//
//  DetailsViewController.swift
//  TMDB-WA-101
//
//  Created by Mykhailo Vorontsov on 12/06/2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var didSelectedClosure: (() -> ())?
    
    deinit {
        print("\(self) destroyed")
    }

    @IBOutlet weak var movieNameLabel: UILabel!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieNameLabel.text = movie?.title ?? "no movie"
    }
    

}
