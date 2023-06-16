import UIKit
import CoreData

class FetchedResultsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var pageLoaded = 0

    lazy var fetchedResultsController: NSFetchedResultsController<MovieDB> = {
        let request = NSFetchRequest<MovieDB>(entityName: "Movie")
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        CoreDataController.shared.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        let resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataController.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultsController.delegate = self
        
        return resultsController
    }()

    let dataController = FallbackDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        try? fetchedResultsController.performFetch()
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func loadData() {
        Task.init {
            do {
                pageLoaded += 1
                _ = try await dataController.loadData(page: pageLoaded)
            } catch {
                print("Error\(error)")
            }
        }

    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        guard indexPath.item < fetchedResultsController.fetchedObjects?.count ?? 0 else { return cell}
        
        
        let movie: MovieDB = fetchedResultsController.object(at: indexPath)
        
        var config = cell.defaultContentConfiguration()
        config.text = movie.title
        
        cell.contentConfiguration = config
        
        if indexPath.row + 1 == fetchedResultsController.fetchedObjects?.count {
            loadData()
        }
        
        return cell
    }
    
    // MARK: - Fetched Results
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        case .insert:
            if let newIndexPath  {
                tableView.insertRows(at: [newIndexPath], with: .right)
            }
        case .move:
            if let newIndexPath, let indexPath  {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
            
        default:
            break;
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
