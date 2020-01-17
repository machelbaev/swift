//
//  DetailViewController.swift
//  CommitsApp
//
//  Created by Mikhail on 16.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var detailItem: Commit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        if let detail = self.detailItem {
            detailLabel.text = detail.message
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Commit 1/\(detail.author.commits.count)", style: .plain, target: self, action: #selector(showAuthorCommits))
        }
    }
    
    @objc func showAuthorCommits() {
        tableView.isHidden = !tableView.isHidden
    }

}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItem?.author.commits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailedCommit", for: indexPath)
        let commit = (detailItem?.author.commits.allObjects as! [Commit])[indexPath.item]
        cell.textLabel?.text = commit.message
        cell.detailTextLabel?.text = "By \(commit.author.name) on \(commit.date.description)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
