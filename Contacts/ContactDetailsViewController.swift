import UIKit

class ContactDetailsViewController: UIViewController, UITableViewDataSource {
    
    var mainVC: ContactsViewController?
    var isNewContact: Bool = false
    var textField: UITextField?
    @IBOutlet weak var numberTextField: UITextField!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldTableViewCell
        switch indexPath.row {
            case 0:
                cell.textField.placeholder = "First Name"
                cell.textField.text = contact.firstName
            case 1:
                cell.textField.placeholder = "Last name"
                cell.textField.text = contact.lastName
            case 2:
                cell.textField.placeholder = "Company"
                cell.textField.text = contact.company
            case 3:
                cell.textField.placeholder = "Email"
                cell.textField.text = contact.email
            case 4:
                cell.textField.placeholder = "Date of Birth"
                cell.textField.text = ""
            default:
                cell.textField.text = contact.fullName
            }
        return cell
    }
    
    @IBOutlet weak var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        if(checkContact()) {
            changeContact(newContact: contact)
            do {
                try mainVC?.context?.save()
            } catch let error as NSError{
                print(error.localizedDescription)
            }
            if(isNewContact) {
                mainVC?.appendContact(contact: contact)
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    public var contact: Contact = Contact()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "TextFieldCell")
        if (contact.fullName.count < 2) {
            navigationItem.title = "New contact"
        }
        else {
            navigationItem.title = contact.fullName
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        numberTextField.placeholder = "Phone number"
        if(contact.number?.count == 11) {
            let formatedNumber = formatNumber(number: contact.number ?? "", shoulRemoveLastDigit: false)
            numberTextField.text = formatedNumber
        }
        else { numberTextField.text = contact.number }
        numberTextField.keyboardType = .numberPad
        numberTextField.textColor = .systemBlue
        numberTextField.delegate = self
    }
    
    private func changeContact(newContact: Contact) {
        newContact.number = numberTextField.text ?? ""
        
        for i in 0...4 {
            let cell = table.cellForRow(at: IndexPath(row: i, section: 0)) as! TextFieldTableViewCell
            let text = cell.textField.text!
            switch i{
                case 0:
                    newContact.firstName = text
                    break
                case 1:
                    newContact.lastName = text
                    break
                case 2:
                    newContact.company = text
                    break
                case 3:
                    newContact.email = text
                    break
                case 4:
                    newContact.birthday = text
                    break
                default:
                    break
            }
        }
    }
    
    private func checkContact() -> Bool {
        let firstNameCell = table.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldTableViewCell
        let firstNameText = firstNameCell.textField.text!
        let lastNameCell = table.cellForRow(at: IndexPath(row: 1, section: 0)) as! TextFieldTableViewCell
        let lastNameText = lastNameCell.textField.text!
        let emailCell = table.cellForRow(at: IndexPath(row: 4, section: 0)) as! TextFieldTableViewCell
        let emailText = emailCell.textField.text!
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let nameReg = "^[a-zA-Zа-яА-Я]+$"
        let nameAlert = UIAlertController(title: "Error", message: "Please, type correct name", preferredStyle: .alert)
        let emailAlert = UIAlertController(title: "Error", message: "Please, type correct email", preferredStyle: .alert)
        
        return check(text: firstNameText, reg: nameReg, alert: nameAlert) &&
        check(text: lastNameText, reg: nameReg, alert: nameAlert) &&
        check(text: emailText, reg: emailReg, alert: emailAlert)
    }
    
    private func check(text: String, reg: String, alert: UIAlertController) -> Bool {
        if(text.isEmpty){ return true}
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        if((text.range(of: reg, options: .regularExpression)) == nil){
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    private func formatNumber(number: String, shoulRemoveLastDigit: Bool) -> String {

        let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
        let range = NSString(string: number).range(of: number)
        let maxNumberCount = 11
        var phoneNumber = regex.stringByReplacingMatches(in: number, options: [], range: range, withTemplate: "")
        if(number.count > maxNumberCount) {
            let maxIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: maxNumberCount)
            phoneNumber = String(phoneNumber[phoneNumber.startIndex..<maxIndex])
        }
        
        if(shoulRemoveLastDigit) {
            let maxIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: phoneNumber.count - 1)
            phoneNumber = String(phoneNumber[phoneNumber.startIndex..<maxIndex])
        }
        
        let maxIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: phoneNumber.count)
        let regRange = phoneNumber.startIndex..<maxIndex
        if(number.count < 7) {
            let pattern = "(\\d)\\(d{3})(\\d+)"
            phoneNumber = phoneNumber.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        }
        else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            phoneNumber = phoneNumber.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        return "+" + phoneNumber
    }
}

extension ContactDetailsViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        textField.text = formatNumber(number: fullString, shoulRemoveLastDigit: range.length == 1)
        return false
    }
}
