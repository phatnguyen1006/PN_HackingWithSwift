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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPersistentContainer()
        fetchJSON()
        
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
            if let error = error {
                print("Unresolved error: \(error)")
            }
        }
    }
    
    func fetchJSON() {
        performSelector(inBackground: #selector(fetchCommits), with: nil)
    }
    
    func configure(commit: Commit, usingJSON json: JSON) {
        
    }
    
        
    @objc func fetchCommits() {
        if let data = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100")!) {
            let jsonCommit = JSON(parseJSON: data)
            
            let jsonCommitArray = jsonCommit.arrayValue
            
            print("Received \(jsonCommitArray.count) new commits.")
            
            DispatchQueue.main.async { [unowned self] in
                for jsonCommit in jsonCommitArray {
                    let commit = Commit(context: self.container.viewContext)
                    self.configure(commit: commit, usingJSON: jsonCommit)
                }
                
                self.saveContext()
            }
        }
    }
}

