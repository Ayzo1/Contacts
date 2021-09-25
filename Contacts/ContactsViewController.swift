import UIKit

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    public var contacts: [Contact] = [
        Contact(firstName: "Ivan", lastName: "Ivanov", number: "89121112233"),
        Contact(firstName: "Petr", lastName: "Petrov", number: "89125556677"),
        Contact(firstName: "Pavel", lastName: "Pavlov", number: "89129997788"),
    ]
    
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
        let contact = Contact(firstName: "", lastName: "", number: "")
        contactDetailsViewController.contact = contact
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
        print(contacts.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        contactsTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
            contactsTableView.reloadData()
        }
    }
    
    private func filterContent(searchText: String) {
        searchResult = contacts.filter({ (contact: Contact) -> Bool in
            let nameMatch = contact.fullName.range(of: searchText)
            return nameMatch != nil
        })
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        contacts.remove(at: indexPath.row)
        contactsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(searchController.isActive) { return false }
        return true
    }
}