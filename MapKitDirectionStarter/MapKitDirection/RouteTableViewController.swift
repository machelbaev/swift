//
//  RouteTableViewController.swift
//  MapKitDirection
//
//  Created by Mikhail on 24.01.2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class RouteTableViewController: UITableViewController {
    
    var routeSteps = [MKRoute.Step]() {
        didSet {
            // For some reason 1 item in route steps is equal "", so we remove it
            if routeSteps[0].instructions == "" {
                routeSteps.remove(at: 0)
            }
        }
    }

    // MARK: - Table view data source

    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeSteps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = routeSteps[indexPath.row].instructions

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
