//
//  DataFlowController.swift
//  TMDB-WA-101
//
//  Created by Michael Vorontsov on 31/05/2023.
//

import Foundation
import UIKit.UIImage

typealias UIImage = UIKit.UIImage

protocol DataFetching {
    func loadData(page: Int) async throws -> [Movie]
    func loadImage(from path: String) async throws -> UIImage
}

enum CommonErrors: Error {
    case unexpected
}

class DataFlowController: DataFetching {
    let networkController: DataFetching
    let cacheController: DataCaching
    
    init(
        netController: DataFetching = NetworkController(),
        cacheController: DataCaching = CoreDataController.shared
    ) {
        self.cacheController = cacheController
        self.networkController = netController
    }
    
    func loadImage(from path: String) async throws -> UIImage {
        try await networkController.loadImage(from: path)
    }
    
    func loadData(page: Int = 1) async throws -> [Movie] {
        
        if
            page == 1,
            let cachedMovies = try? await cacheController.loadData(page: 1),
            cachedMovies.count > 0
        {
            return cachedMovies
        }
        
        
        let movies = try await networkController.loadData(page: page)
        cacheController.save(movies: movies)
            
        return movies
            
    }
    
}
