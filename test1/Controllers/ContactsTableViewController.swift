//
//  ContactsTableViewController.swift
//  test1
//
//  Created by curry敏 on 2021/7/5.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController {
    
    var contacts =  [Contact]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: - TableView Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath)
        
        cell.textLabel?.text = contacts[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(contacts[indexPath.row])
            self.contacts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            saveContacts()
        }
    }
    


    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? DetailsTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC?.selectedContact = contacts[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation
    func saveContacts(){
        do{
            try context.save()
        }
        catch {
            print("Error saving data: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadContacts() {
        let request : NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
            contacts = try context.fetch(request)
        }
        catch {
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add Button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        let alert = UIAlertController(title: "Add New Contact", message: "", preferredStyle: .alert)
        //Add name
        alert.addTextField { name in
            name.placeholder = "Name"
        }
        //Add phone number
        alert.addTextField { phone in
            phone.placeholder = "Mobile"
        }
        alert.addTextField { company in
            company.placeholder = "Company"
        }
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newContact = Contact(context: self.context)
            newContact.name = alert.textFields![0].text
            newContact.mobile = alert.textFields![1].text
            if let companyText = alert.textFields?[2] {
                newContact.company = companyText.text
            }
            self.contacts.append(newContact)
            self.saveContacts()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { cancel in
            print("Cancel")
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension ContactsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Contact> = Contact.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            contacts = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadContacts()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
