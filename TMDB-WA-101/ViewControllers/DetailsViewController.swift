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
        
        didSelectedClosure = { [weak self] in
            self?.printMessage()
        }

        movieNameLabel.text = movie?.title ?? "no movie"

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let closure = didSelectedClosure else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            closure()
        }
    }
    
    func printMessage() {
        print("blah-blah")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
