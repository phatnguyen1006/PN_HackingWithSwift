//
//  ViewController.swift
//  GitHub Commit
//
//  Created by Phat Nguyen on 13/01/2022.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sqlite()
        saveContext()
        createCommit()
    }
    
    func sqlite() {
        /**
          1 Load our data model we just created from the application bundle and create a NSManagedObjectModel object from it.
          2 Create an NSPersistentStoreCoordinator object, which is responsible for reading from and writing to disk.
          3 Set up a URL pointing to the database on disk where our actual saved objects live. This will be an SQLite database named Project38.sqlite.
          4 Load that database into the NSPersistentStoreCoordinator so it knows where we want it to save. If it doesn't exist, it will be created automatically
          5 Create an NSManagedObjectContext and point it at the persistent store coordinator.
         */
        
        container = NSPersistentContainer(name: "GithubCommit")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }

    func createCommit() {
        let commit = Commit()
        commit.date = Date()
        commit.message = "Commit"
        commit.url = "https://example.com"
    }
}

