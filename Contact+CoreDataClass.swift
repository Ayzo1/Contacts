import Foundation
import CoreData


public class Contact: NSManagedObject {
    
    
    public var fullName: String {
        if(lastName != nil && firstName != nil) {
            return lastName! + " " + firstName!
        }
        return ""
    }

    /*
    init(firstNam: String, lastNam: String, numbe: String) {
        firstName = firstNam
        lastName = lastNam
        number = numbe
    }
     */
    /*
    public var firstName: String = ""
    public var lastName: String = ""
    public var company: String = ""
    public var birthday: String = ""
    public var email: String = ""
    public var number: String = ""
    public var fullName: String {lastName + " " + firstName}
*/
}
