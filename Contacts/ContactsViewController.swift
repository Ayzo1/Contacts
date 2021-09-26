import UIKit
import CoreData

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    public var contacts: [Contact] = []
    private var appDelegate: AppDelegate?
    private var context: NSManagedObjectContext?
    private var searchResult: [Contact] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var contactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        contactsTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive){
            return searchResult.count
        }
        return contacts.count
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let contactDetailsViewController = storyboard.instantiateViewController(identifier: "ContactDetailsViewController") as! ContactDetailsViewController
        let description = NSEntityDescription.entity(forEntityName: "Contact", in: context!)!
        let contact = NSManagedObject(entity: description, insertInto: context)
        contactDetailsViewController.contact = contact as! Contact
        contactDetailsViewController.mainVC = self
        contactDetailsViewController.isNewContact = true
        navigationController?.pushViewController(contactDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = (searchController.isActive) ? searchResult[indexPath.row] : contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        cell.textLabel?.text = contact.fullName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let contactDetailsViewController = storyboard.instantiateViewController(identifier: "ContactDetailsViewController") as! ContactDetailsViewController
        let contact = contacts[indexPath.row]
        contactDetailsViewController.contact = contact
        contactDetailsViewController.mainVC = self
        navigationController?.pushViewController(contactDetailsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func appendContact(contact: Contact) {
        contacts.append(contact)
        do {
            try context?.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
            contacts = try context?.fetch(fetchRequest) as! [Contact]
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        contactsTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
            contactsTableView.reloadData()
        }
    }
    
    private func filterContent(searchText: String) {
        searchResult = contacts.filter(
            {
                (contact: Contact) -> Bool in
                let nameMatch = contact.fullName.range(of: searchText)
                return nameMatch != nil
            }
        )
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(!searchController.isActive) {
            contacts.remove(at: indexPath.row)
            contactsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(searchController.isActive) { return false }
        return true
    }
}
