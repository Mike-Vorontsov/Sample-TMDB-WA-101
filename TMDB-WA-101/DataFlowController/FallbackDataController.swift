//
//  FallbackDataController.swift
//  TMDB-WA-101
//
//  Created by Michael Vorontsov on 31/05/2023.
//

import Foundation

class FallbackDataController: DataFetching {
    let networkController: DataFetching = NetworkController()
    
//    let networkController: DataFetching = AlwaysFailFetchingController()
    let cacheController: DataCaching = CoreDataController.shared
    
    func loadData(page: Int = 1) async throws -> [Movie] {
        
        do {
            let movies = try await networkController.loadData(page: page)
            cacheController.save(movies: movies)
            return movies
        } catch {
            let cachedMovies = try? await cacheController.loadData(page: 1)
            return cachedMovies ?? []
        }
            
    }
    
}
