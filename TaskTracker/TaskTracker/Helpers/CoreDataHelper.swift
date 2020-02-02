//
//  CoreDataHelper.swift
//  TaskTracker
//
//  Created by Mikhail on 31.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit
import CoreData

class CustomPersistantContainer : NSPersistentContainer {

      static let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.ios.tasks")!
      let storeDescription = NSPersistentStoreDescription(url: url)

      override class func defaultDirectoryURL() -> URL {
        return url
      }
    
}

class CoreDataHelper: NSObject {
    
    class var instance: CoreDataHelper {
        struct Singleton {
            static var instance = CoreDataHelper()
        }
        return Singleton.instance
    }

    var context: NSManagedObjectContext {
      return persistentContainer.viewContext
    }

    lazy var persistentContainer: CustomPersistantContainer = {

      let container = CustomPersistantContainer(name: "Data")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {

          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()

    // MARK: - Core Data Saving support
    
    func saveContext() {
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {

          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
    
//    let coordinator: NSPersistentStoreCoordinator
//    let context: NSManagedObjectContext
//
//    fileprivate override init() {
//        let modelURL = Bundle.main.url(forResource: "Data", withExtension: "momd")
//        let model = NSManagedObjectModel(contentsOf: modelURL!)
//
//        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
//
//        let fileManager = FileManager.default
//
//        let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
//
//        let storeURL = docURL!.appendingPathComponent("store.sqlite")
//
//        do {
//            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
//        } catch let err as NSError {
//            print("Can't open database:", err)
//            abort()
//        }
//
//        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        context.persistentStoreCoordinator = coordinator
//    }
    
}
