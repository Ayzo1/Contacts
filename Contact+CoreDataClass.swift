import Foundation
import CoreData


public class Contact: NSManagedObject {
    
    public var fullName: String {
        if(lastName != nil && firstName != nil) {
            return lastName! + " " + firstName!
        }
        return ""
    }
}
