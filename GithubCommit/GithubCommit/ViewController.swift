//
//  ViewController.swift
//  GithubCommit
//
//  Created by Phát Nguyễn on 22/01/2022.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    var container: NSPersistentContainer!
    // var commits = [Commit]()
    var commitPredicate: NSPredicate?
    var fetchedResultController: NSFetchedResultsController<Commit>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPersistentContainer()
        navBar()
        fetchJSON()
        loadSavedData()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
        
        let commit = fetchedResultController.object(at: indexPath)
        cell.textLabel?.text = commit.message
        cell.detailTextLabel?.text = "By \(commit.author.name) on \(commit.date.description)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.detailItem = fetchedResultController.object(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultController.sections![section].name
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        /**
         1) pulls out the Commit object that the user selected to delete,
         2) removes it from the managed object context,
         3) removes it from the commits array,
         4) deletes it from the table view, then
         5) saves the context.
         * @Remember: you must call saveContext() whenever you want your changes to persist.
         */
        
        if editingStyle == .delete {
            let commit = fetchedResultController.object(at: indexPath)
            container.viewContext.delete(commit)
            
            saveContext()           // save context in core data
        }
    }
    
    func navBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))
    }
    
    func saveContext() {
        /*
         Once you’ve finished your changes and want to write them permanently – i.e., save them to disk – you need to call the save() method on the viewContext property. However, this should only be done if there are any changes since the last save – there’s no point doing unnecessary work. So, before calling save() you should read the hasChanges property.
         */
        /// managed object context: viewContext
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func createPersistentContainer() {
        
        /**
          1. Load our data model we just created from the application bundle and create a NSManagedObjectModel object from it.
          2. Create an NSPersistentStoreCoordinator object, which is responsible for reading from and writing to disk.
          3. Set up a URL pointing to the database on disk where our actual saved objects live. This will be an SQLite database named GithubCommit.sqlite.
          4. Load that database into the NSPersistentStoreCoordinator so it knows where we want it to save. If it doesn't exist, it will be created automatically
          5. Create an NSManagedObjectContext and point it at the persistent store coordinator.
         */
        
        container = NSPersistentContainer(name: "GithubCommit") // NSManagedObjectContext
        
        // loadPersistentStores() method, which loads the saved database if it exists, or creates it otherwise
        container.loadPersistentStores { storeDescription, error in
            /*
             This instructs Core Data to allow updates to objects: if an object exists in its data store with message A, and an object with the same unique constraint ("sha" attribute) exists in memory with message B, the in-memory version "trumps" (overwrites) the data store version.
             */
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error: \(error)")
            }
        }
    }
    
    func loadSavedData() {
        if fetchedResultController == nil {
            // create the fetch request -> create the query
            let request = Commit.createFetchRequest()
            let sort = NSSortDescriptor(key: "author.name", ascending: true)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: "author.name", cacheName: nil)
            fetchedResultController.delegate = self
        }
        
        fetchedResultController.fetchRequest.predicate = commitPredicate
        
        do {
            try fetchedResultController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed.")
        }
    }
    
    func fetchJSON() {
        performSelector(inBackground: #selector(fetchCommits), with: nil)
    }
    
    func configure(commit: Commit, usingJSON json: JSON) {
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["html_url"].stringValue
        
        let formatter = ISO8601DateFormatter()
        commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()
        
        var commitAuthor: Author!
        
        let authorRequest = Author.createFetchRequest()
        authorRequest.predicate = NSPredicate(format: "name == %@", json["commit"]["committer"]["name"].stringValue)
        
        if let authors = try? container.viewContext.fetch(authorRequest) {
            if authors.count > 0 {
                commitAuthor = authors[0]
            }
        }
        
        if commitAuthor == nil {
            // we didn't find saved author - create new one !
            let author = Author(context: container.viewContext)
            author.name = json["commit"]["committer"]["name"].stringValue
            author.email = json["commit"]["committer"]["email"].stringValue
            commitAuthor = author
        }
        
        commit.author = commitAuthor
    }
    
    func getNewestCommitDate() -> String {
        let formatter = ISO8601DateFormatter()
        
        let newest = Commit.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        newest.sortDescriptors = [sort]
        newest.fetchLimit = 1
        
        // fetch the newst
        if let commits = try? container.viewContext.fetch(newest) {
            if commits.count > 0 {
                return formatter.string(from: commits[0].date.addingTimeInterval(1))    // return the date + 1(s)
            }
        }
        
        return formatter.string(from: Date(timeIntervalSince1970: 0))
    }
        
    @objc func fetchCommits() {
        let newestCommitDate = getNewestCommitDate()
        
        if let data = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100&since=\(newestCommitDate)")!) {
            let jsonCommit = JSON(parseJSON: data)
            
            let jsonCommitArray = jsonCommit.arrayValue
            
            print("Received \(jsonCommitArray.count) new commits.")
            
            DispatchQueue.main.async { [unowned self] in
                for jsonCommit in jsonCommitArray {
                    let commit = Commit(context: self.container.viewContext)
                    self.configure(commit: commit, usingJSON: jsonCommit)
                }
                
                self.saveContext()
                self.loadSavedData()
            }
        }
    }
    
    @objc func changeFilter() {
        // MARK: - Filter Actions
        let ac = UIAlertController(title: "Filter commits ...", message: nil, preferredStyle: .actionSheet)
        
        // 1
        ac.addAction(UIAlertAction(title: "Show only fixes", style: .default, handler: { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'")
            self.loadSavedData()
        }))
        // 2
        ac.addAction(UIAlertAction(title: "Ignore Pull Request", style: .default, handler: { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
            self.loadSavedData()
        }))
        // 3
        ac.addAction(UIAlertAction(title: "Show only recent", style: .default, handler: { [unowned self] _ in
            let twelveHoursAgo = Date().addingTimeInterval(-43200)
            self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo as NSDate)
            self.loadSavedData()
        }))
        // 4
        ac.addAction(UIAlertAction(title: "Show only Durian commits", style: .default, handler: { [unowned self] _ in
            self.commitPredicate = NSPredicate(format: "author.name == 'Joe Groff'")
            self.loadSavedData()
        }))
        // 5
        ac.addAction(UIAlertAction(title: "Show all commits", style: .default, handler: { [unowned self] _ in
            self.commitPredicate = nil
            self.loadSavedData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        
        default:
            break
        }
    }
}
