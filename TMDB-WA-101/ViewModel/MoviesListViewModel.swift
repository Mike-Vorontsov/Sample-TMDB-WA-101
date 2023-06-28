//
//  MoviesListViewModel.swift
//  TMDB-WA-101
//
//  Created by Mykhailo Vorontsov on 28/06/2023.
//

import Foundation

protocol MoviesListViewModelDelegate: AnyObject {
    func moviesDidLoad(_ movies: [MovieViewModel])
}

class MoviesListViewModel {
    
    
    var movies: [MovieViewModel] = []
    
    weak var delegate: MoviesListViewModelDelegate?
    
    private let dataController: DataFetching
    
    init(dataController: DataFetching) {
        self.dataController = dataController
    }
    
    func viewReady() {
        loadData()
    }
    
    // MARK: - Helpers
    
    private func loadData() {
        Task.init {
            do {
                let movies = try await dataController.loadData(page: 1)
                
                let viewModels = movies.map {
                    MovieViewModel(
                        title: $0.title,
                        posterPath: $0.poster,
                        dataController: self.dataController
                    )
                }
                
                
                self.movies = viewModels
                
                delegate?.moviesDidLoad(viewModels)
                
            } catch {
                print("Error\(error)")
            }
        }

    }
    
}
