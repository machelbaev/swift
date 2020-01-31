//
//  TasksController.swift
//  TaskTracker
//
//  Created by Mikhail on 31.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

enum TaskType {
    case new, existed
}

enum TaskStatus: String {
    case inProgress = "В процессе"
    case new = "Новые"
    case completed = "Выполнено"
}

class TasksController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let headers = ["В ПРОЦЕССЕ", "НОВЫЕ", "ВЫПОЛНЕНО"]
    var newTasks = [Task]()
    var inProgressTasks = [Task]()
    var completedTasks = [Task]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        fetchTasks()
    }
    
    private func fetchTasks() {
        newTasks.removeAll()
        inProgressTasks.removeAll()
        completedTasks.removeAll()
        let tasks = Task.allTasks()
        tasks.forEach { (task) in
            switch TaskStatus(rawValue: task.status) {
            case .inProgress:
                self.inProgressTasks.append(task)
            case .new:
                self.newTasks.append(task)
            default:
                self.completedTasks.append(task)
            }
        }
        tableView.reloadData()
    }
    
    private func openTask(taskType: TaskType, task: Task?) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailedTask") as? DetailedTaskController {
            vc.title = taskType == .existed ? "Задача" : "Новая задача"
            if let task = task {
                vc.task = task
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func createTask(_ sender: Any) {
        openTask(taskType: .new, task: nil)
    }
    
}

extension TasksController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return inProgressTasks.count
        case 1:
            return newTasks.count
        default:
            return completedTasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "TasksHeaderID") as! TasksHeader
        if section != 0 {
            header.offset.constant = 0
            header.circle.backgroundColor = .clear
            header.numberOfTasks.textColor = UIColor(named: "gray")
        }
        header.tasksHeader.text = headers[section]
        switch section {
        case 0:
            header.numberOfTasks.text = "\(inProgressTasks.count)"
        case 1:
            header.numberOfTasks.text = "\(newTasks.count)"
        default:
            header.numberOfTasks.text = "\(completedTasks.count)"
        }
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCellID", for: indexPath) as! TasksCell
        switch indexPath.section {
        case 0:
            cell.task = inProgressTasks[indexPath.item]
        case 1:
            cell.task = newTasks[indexPath.item]
        default:
            cell.task = completedTasks[indexPath.item]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = (tableView.cellForRow(at: indexPath) as! TasksCell).task
        openTask(taskType: .existed, task: task)
    }
    
}



