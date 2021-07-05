//
//  DetailsTableViewController.swift
//  test1
//
//  Created by curry敏 on 2021/7/5.
//

import UIKit
import CoreData

class DetailsTableViewController: UITableViewController {
    
    @IBOutlet var mobileTextField: UITextField!
    @IBOutlet var companyTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var details = [Contact]()
    
    var editStatus: Bool = false
    
    var selectedContact: Contact? {
        didSet {
            print("Loading data")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedContact?.name
        loadDetails()
        self.mobileTextField.text = selectedContact?.mobile
        self.companyTextField.text = selectedContact?.company
        companyTextField.isUserInteractionEnabled = false
        mobileTextField.isUserInteractionEnabled = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */



    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    
    //MARK: - Data Manipulation
    func loadDetails() {
        let request : NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
        details = try context.fetch(request)
        } catch {
            print("Erro fetching data: \(error)")
        }
    }
    
    func updateDetails() {
        do {
        try context.save()
        } catch {
            print("Error saving data: \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: - Edit Button
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        editStatus = !editStatus
        sender.title = (editStatus) ? "Done" : "Edit"
        companyTextField.isUserInteractionEnabled = true
        mobileTextField.isUserInteractionEnabled = true
        selectedContact?.mobile = mobileTextField.text
        selectedContact?.company = companyTextField.text
        updateDetails()
    }
    

    
}
