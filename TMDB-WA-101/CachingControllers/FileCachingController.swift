//
//  FileCachingController.swift
//  TMDB-WA-101
//
//  Created by Michael Vorontsov on 31/05/2023.
//

import Foundation

class FileCachingController: DataCaching {
    
    let fileManager = FileManager.default
    let fileName = "cache.json"
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    lazy var fileUrl: URL = {
        let documentsUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        let fileUrl = documentsUrl.appending(path: fileName)
        
        return fileUrl
    }()
    
    func loadData(page: Int) async throws -> [Movie] {

        let data = try Data(contentsOf: fileUrl)
        let movies = try JSONDecoder().decode([Movie].self, from: data)
        
        return [Movie(title: "File Cached:")] + movies
    }
    
    func save(movies: [Movie]) {
        guard
            let data = try? encoder.encode(movies)
        else {
            return
        }
        
        try? data.write(to: fileUrl)
    }
 
    
}
