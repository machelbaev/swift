//
//  DetailedTaskController.swift
//  TaskTracker
//
//  Created by Mikhail on 31.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class DetailedTaskController: UIViewController {
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: PlaceholderTextView! {
        didSet {
            taskDescription.setPlaceholder(14, "Опишите вашу задачу")
            taskDescription.layer.borderWidth = 0.5
            taskDescription.layer.borderColor = UIColor(named: "gray")?.cgColor
        }
    }
    @IBOutlet weak var statusController: UISegmentedControl!
    var task: Task?
    
    override func viewDidLoad() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        setupStatusController()
        setValues()
    }
    
    private func setValues() {
        guard let task = task else { return }
        taskTitle.text = task.title
        taskDescription.text = task.taskDescription
        taskDescription.placeholderLabel.isHidden = true
        var index: Int
        switch TaskStatus(rawValue: task.status) {
        case .inProgress:
            index = 0
        case .new:
            index = 1
        default:
            index = 2
        }
        statusController.selectedSegmentIndex = index
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteTask))
    }
    
    @objc private func deleteTask() {
        guard let task = task else { return }
        let alert = UIAlertController(title: "Удалить задачу", message: "Вы уверены, что хотите удалить задачу?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ок", style: .default) { (_) in
            CoreDataHelper.instance.context.delete(task)
            try! CoreDataHelper.instance.context.save()
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func hideKeyboard() {
        taskTitle.resignFirstResponder()
        taskDescription.resignFirstResponder()
    }
    
    @IBAction func saveTask(_ sender: Any) {
        if !checkAbilityToSave() {
            return
        }
        
        if task == nil {
            task = Task()
        }
        task!.status = statusController.titleForSegment(at: statusController.selectedSegmentIndex)!
        task!.taskDescription = taskDescription.text ?? ""
        task!.title = taskTitle.text ?? ""
        try! CoreDataHelper.instance.context.save()
        navigationController?.popViewController(animated: true)
    }
    
    private func checkAbilityToSave() -> Bool {
        var canSave: Bool = true
        if taskTitle.text?.count == 0 {
            canSave = false
            UIView.animate(withDuration: 1) {
                self.taskTitle.backgroundColor = UIColor(named: "red")
                self.taskTitle.backgroundColor = .clear
            }
        }
        if taskDescription.text.count == 0 {
            canSave = false
            UIView.animate(withDuration: 1) {
                self.taskDescription.backgroundColor = UIColor(named: "red")
                self.taskDescription.backgroundColor = .clear
            }
        }
        return canSave
    }
    
    private func setupStatusController() {
        statusController.setTitle(TaskStatus.inProgress.rawValue, forSegmentAt: 0)
        statusController.setTitle(TaskStatus.new.rawValue, forSegmentAt: 1)
        statusController.setTitle(TaskStatus.completed.rawValue, forSegmentAt: 2)
    }
    
}
