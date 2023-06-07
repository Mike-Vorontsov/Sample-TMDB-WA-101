//
//  DataFlowControllerTests.swift
//  TMDB-WA-101Tests
//
//  Created by Michael Vorontsov on 07/06/2023.
//

import XCTest
@testable import TMDB_WA_101

final class DataFlowControllerTests: XCTestCase {
    
    private var sutDataController: DataFlowController!
    private var mockDataFetchingController: MockCachingController!
    private var mockDataCachingController: MockCachingController!

    override func setUpWithError() throws {
        mockDataCachingController = MockCachingController()
        mockDataFetchingController = MockCachingController()
        sutDataController = DataFlowController(
            netController: mockDataFetchingController,
            cacheController: mockDataCachingController
        )
    }

    override func tearDownWithError() throws {
        mockDataCachingController = nil
        sutDataController = nil
    }

    func testWhenLoadPage1ThenTryToLoadFromCache() async throws {
        // Given
        mockDataCachingController.moviesToLoad = [Movie(title: "MockedMovie")]
        
        // When
        let results = try await sutDataController.loadData(page: 1)
        
        // Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "MockedMovie")
    }

    func testWhenLoadPage2ThenNotTryToLoadFromCache() async throws {
        // Given
        mockDataCachingController.moviesToLoad = [Movie(title: "MockedCachedMovie")]
        mockDataFetchingController.moviesToLoad = [Movie(title: "MockedNetMovie")]
        
        // When
        let results = try await sutDataController.loadData(page: 2)
        
        // Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "MockedNetMovie")
    }
    
    func testWhenLoadPage2AndNetowkrFailedThenGotError() async throws {
        // Given
        mockDataCachingController.moviesToLoad = [Movie(title: "MockedCachedMovie")]
        
        // When
        var catchedError: Error?
        do {
            _ = try await sutDataController.loadData(page: 2)
        } catch {
            catchedError = error
        }
        
        
        // Then
        XCTAssertNotNil(catchedError)
        XCTAssertEqual(catchedError as? MockCachingController.MockError, .noMoviesMocked)
    }
    
}

private class MockCachingController: DataCaching {
    enum MockError: Error {
        case noMoviesMocked
    }
    
    var savedMovies: [TMDB_WA_101.Movie]?
    var moviesToLoad: [TMDB_WA_101.Movie]?
    
    func save(movies: [TMDB_WA_101.Movie]) {
        savedMovies = movies
    }
    
    func loadData(page: Int) async throws -> [TMDB_WA_101.Movie] {
        if let moviesToLoad {
            return moviesToLoad
        }
        throw MockError.noMoviesMocked
    }
}

