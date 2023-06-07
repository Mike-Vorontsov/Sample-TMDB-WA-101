//
//  CoreDataController.swift
//  TMDB-WA-101
//
//  Created by Michael Vorontsov on 31/05/2023.
//

import Foundation
import CoreData
// MARK: - Core Data stack

class CoreDataController: DataCaching {
    
    static let shared = CoreDataController()
    
    private init() {}
        
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreDataDemo1")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func loadData(page: Int) async throws -> [Movie] {
        let context = persistentContainer.viewContext
        var movies: [Movie] = []
        
        try? context.performAndWait {
            let request = NSFetchRequest<MovieDB>(entityName: MovieDB.entity().name!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            let results = try request.execute()
            movies =  results.map { Movie(title: $0.title ?? "") }
        }
        return [Movie(title: "CoreData cached")] + movies
    }
    
    func save(movies: [Movie]) {
        persistentContainer.performBackgroundTask { context in
            
            movies.forEach {
                let dbObject = MovieDB(context: context)
                dbObject.title = $0.title
            }
            try? context.save()
        }
        
//        let bgContext = self.persistentContainer.newBackgroundContext()
//
//        bgContext.perform {
//
//        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
