//
//  AlwaysFailFetchingController.swift
//  TMDB-WA-101
//
//  Created by Michael Vorontsov on 31/05/2023.
//

import Foundation



class AlwaysFailFetchingController: DataFetching {
    func loadImage(from path: String) async throws -> UIImage {
        throw SomeError.always
    }
    
    
    enum SomeError: Error {
        case always
    }
    
    func loadData(page: Int) async throws -> [Movie] {
        throw SomeError.always
    }
}
