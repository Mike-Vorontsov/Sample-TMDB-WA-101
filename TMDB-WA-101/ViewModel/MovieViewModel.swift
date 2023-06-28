//
//  MovieViewModel.swift
//  TMDB-WA-101
//
//  Created by Mykhailo Vorontsov on 28/06/2023.
//

import Foundation
import UIKit.UIImage

protocol MovieViewModelDelegate: AnyObject {
    func imageDidLoad(_ image: UIImage)
}

class MovieViewModel {
    internal init(title: String, posterPath: String, dataController: DataFetching) {
        self.title = title
        self.posterPath = posterPath
        self.dataController = dataController
    }
    
    let title: String
    let posterPath: String
    
    
    private let dataController: DataFetching
    
    
    var poster: UIImage?
    weak var delegate: MovieViewModelDelegate?
    
    func viewReady() {
        if poster != nil {
            return
        }
        
        Task {
            do {
                let image = try await dataController.loadImage(from: posterPath)
                self.poster = image
                
                delegate?.imageDidLoad(image)
                
            }catch {
                print("Error: \(error)")
            }
        }
    }
    
}
