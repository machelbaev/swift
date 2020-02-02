//
//  TodayViewController.swift
//  TaskWidget
//
//  Created by Mikhail on 31.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var text: UILabel!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text.text = "Нет выполняющихся задач"
        setLabel()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openApp)))
    }
    
    private func setLabel() {
        let tasks = Task.allTasks()
        tasks.reversed().forEach { (task) in
            if TaskStatus(rawValue: task.status) == .inProgress {
                text.text = task.title
                self.task = task
                return
            }
        }
    }
    
    @objc private func openApp() {
        var id = ""
        if let task = task {
            id = task.id
        }
        self.extensionContext?.open(URL(string: "widgetToApp://\(id)")!, completionHandler: nil)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        setLabel()        
        completionHandler(NCUpdateResult.newData)
    }
    
}
