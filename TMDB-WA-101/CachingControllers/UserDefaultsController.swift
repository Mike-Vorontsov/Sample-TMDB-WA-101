//
//  UserDefaultsController.swift
//  TMDB-WA-101
//
//  Created by Michael Vorontsov on 31/05/2023.
//

import Foundation

protocol DataCaching: DataFetching {
    func save(movies: [Movie])
}

class UserDefaultsController: DataCaching {
        
    let defaults = UserDefaults.standard
    let key = "movies"
    let dateKey = "last_update"
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func save(movies: [Movie]) {
        if let data = try? encoder.encode(movies) {
            defaults.set(data, forKey: key)
            defaults.set(Date(), forKey: dateKey)
        }
    
    }
    
    func loadData(page _: Int) async throws -> [Movie] {
        guard
            let data = defaults.data(forKey: key),
            let movies = try? decoder.decode([Movie].self, from: data)
        else {
            return []
        }
        
        return [Movie(title: "Cached!")] + movies
    }
    
}
