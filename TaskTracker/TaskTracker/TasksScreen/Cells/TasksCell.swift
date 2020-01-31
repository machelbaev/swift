//
//  TasksCell.swift
//  TaskTracker
//
//  Created by Mikhail on 31.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class TasksCell: UITableViewCell {
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var taskDescription: UITextView! {
        didSet {
            taskDescription.textContainer.lineFragmentPadding = 0
        }
    }
    
    var task: Task? {
        didSet {
            taskTitle.text = task!.title
            taskDescription.text = task!.taskDescription
            date.text = task!.date.timeAgoDisplayRussian()
        }
    }
    
    
}
