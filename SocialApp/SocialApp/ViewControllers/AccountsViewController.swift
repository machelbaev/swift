//
//  AccountsViewController.swift
//  SocialApp
//
//  Created by Mikhail on 18.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit
import Accounts

class AccountsViewController: UITableViewController {
    
    var twitterAccounts : [Any]?
    var accountStore : ACAccountStore?

    override func viewDidLoad() {
        super.viewDidLoad()

        accountStore = ACAccountStore()
        let accountType = accountStore!.accountType(withAccountTypeIdentifier: "ACAccountTypeIdentiﬁerTwitter")
        accountStore?.requestAccessToAccounts(with: accountType, options: nil, completion: { granted, error in
            if(granted) {
                self.twitterAccounts = self.accountStore!.accounts(with: accountType)
                if (self.twitterAccounts!.count == 0) {
                    let noAccountsAlert = UIAlertController(title: "No Accounts Found", message: "No Twitter accounts were found.", preferredStyle: .alert)
                    let dismissButton = UIAlertAction(title: "Okay", style: .cancel) {
                        alert in
                        noAccountsAlert.dismiss(animated: true, completion: nil)
                    }
                    noAccountsAlert.addAction(dismissButton)
                    DispatchQueue.main.async() {
                        self.present(noAccountsAlert, animated: true, completion: nil)

                    }

                } else {
                    DispatchQueue.main.async() {
                        self.tableView.reloadData()
                    }
                }
            }

        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cellCount = self.twitterAccounts?.count {
            return cellCount
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        return cell
    }

}
