//
//  Contact.swift
//  Contacts
//
//  Created by Justin Lowry on 1/14/22.
//

import Foundation
import CloudKit

struct ContactStrings {
    static let recordTypeKey = "Contact"
    fileprivate static let nameKey = "name"
    fileprivate static let phoneNumberKey = "phoneNumber"
    fileprivate static let emailKey = "email"
} // End of struct

class Contact {
    var name: String
    var phoneNumber: String?
    var email: String?
    var recordID: CKRecord.ID
    
    init(name: String, phoneNumber: String?, email: String?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.recordID = recordID
    }
} // End of class


extension Contact {
    /**
     Unpacking a Contact model from a CKRecord
     */
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[ContactStrings.nameKey] as? String
        else { return nil }
        
        let phoneNumber = ckRecord[ContactStrings.phoneNumberKey] as? String
        let email = ckRecord[ContactStrings.emailKey] as? String
        
        self.init(name: name, phoneNumber: phoneNumber, email: email, recordID: ckRecord.recordID)
    }
} // End of extension

extension CKRecord {
    /**
     Packing a Contact model into a CKRecord
     */
    convenience init(contact: Contact) {
        self.init(recordType: ContactStrings.recordTypeKey, recordID: contact.recordID)
        self.setValuesForKeys([
            ContactStrings.nameKey : contact.name
        ])
        
        if let phoneNumber = contact.phoneNumber {
            self.setValue(phoneNumber, forKey: ContactStrings.phoneNumberKey)
        }
        
        if let email = contact.email {
            self.setValue(email, forKey: ContactStrings.emailKey)
        }
    }
} // End of extension
