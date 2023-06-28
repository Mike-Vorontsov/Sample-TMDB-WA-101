//
//  NetworkController.swift
//  TMDB-WA-101
//
//  Created by Michael Vorontsov on 24/05/2023.
//

import Foundation

class NetworkController: DataFetching {
    
    enum NetErrors: Error {
        case notImage
    }

    let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2OWI1OTAzMTFiZjFhYjI3NjBkMjk3ZTQ4MGViM2JlMiIsInN1YiI6IjY0NmJkMWRmMmJjZjY3MDE3MmIyOTUxMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.GBRh-SFoqFGKXv-sRjZsewvQrakSbf0CevG1xFzW2Es"
    ]
    
    let decoder = JSONDecoder()
    let session = URLSession.shared
    var lastPageLoaded = 0
    
    func loadNextPage() async throws -> [Movie]  {
        defer {
            lastPageLoaded += 1
        }
        return try await loadData(page: lastPageLoaded + 1)
    }
    
    func loadData(page: Int = 1) async throws -> [Movie] {
        
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=\(page)&sort_by=popularity.desc")!
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = headers
        
        let sessionResponse = try await session.data(for: request)
        let moviesResponse = try decoder.decode(MoviesResponse.self, from: sessionResponse.0)
        
        return moviesResponse.results
    }
    
    func loadImage(from path: String) async throws -> UIImage {
        let url = URL(string: "https://image.tmdb.org/t/p/w154/\(path)")!
        
        let sessionResponse = try await session.data(from: url)
        
        guard let image = UIImage(data: sessionResponse.0) else {
            throw NetErrors.notImage
        }
        
        return image
    }
}
