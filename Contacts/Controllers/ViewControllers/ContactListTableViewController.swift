//
//  ContactListTableViewController.swift
//  Contacts
//
//  Created by Justin Lowry on 1/14/22.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }

        let contact = ContactController.shared.contacts[indexPath.row]
        
        cell.nameLabel.text = contact.name
        cell.phoneNumberLabel.text = contact.phoneNumber

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let contactToDelete = ContactController.shared.contacts[indexPath.row]
            
            ContactController.shared.deleteContact(contactToDelete) { didDelete in
                if didDelete {
                    ContactController.shared.contacts.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } else {
                    print("Could not delete")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Methods
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchContacts() {
        ContactController.shared.fetchContacts { _ in
            self.updateViews()
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        if segue.identifier == "toAddContactVC" {
            guard let  indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? AddContactViewController else { return }
            
            let contact = ContactController.shared.contacts[indexPath.row]
            
            destination.contact = contact
        }
    }
}
