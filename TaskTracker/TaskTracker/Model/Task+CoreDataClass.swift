//
//  Task+CoreDataClass.swift
//  TaskTracker
//
//  Created by Mikhail on 31.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//
//

import Foundation
import CoreData


public class Task: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var date: Date
    @NSManaged public var title: String
    @NSManaged public var taskDescription: String
    @NSManaged public var status: String
    @NSManaged public var id: String
    
    convenience init() {
        self.init(entity: Task.entity(), insertInto: CoreDataHelper.instance.context)
        self.date = Date()
        self.id = UUID().uuidString
    }
    
    convenience init(title: String, taskDescription: String, status: String) {
        self.init()
        self.title = title
        self.taskDescription = taskDescription
        self.status = status
    }

    class func allTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return try CoreDataHelper.instance.context.fetch(fetchRequest) as! [Task]
        } catch {
            return []
        }
    }
    
    class func findById(_ id: String) -> Task {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let task = try! CoreDataHelper.instance.context.fetch(fetchRequest).first as! Task
        return task
    }
    
}
