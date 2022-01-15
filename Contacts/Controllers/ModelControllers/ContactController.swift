//
//  ContactController.swift
//  Contacts
//
//  Created by Justin Lowry on 1/14/22.
//

import Foundation
import CloudKit

class ContactController {
    /// Shared instance
    static let shared = ContactController()
    /// Source of Truth
    var contacts: [Contact] = []
    /// public cloud database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    // MARK: - Methods
    // CRUD
    
    func createContact(name: String, phoneNumber: String?, email: String?, completion: @escaping (Bool) -> Void) {
        // Creating Contact
        let newContact = Contact(name: name, phoneNumber: phoneNumber, email: email)
        
        // Convert to CKRecord
        let ckRecord = CKRecord(contact: newContact)
        
        // Save to CloudKit
        privateDB.save(ckRecord) { ckRecord, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                return completion(false)
            }
            
            guard let ckRecord = ckRecord,
                  let contact = Contact(ckRecord: ckRecord) else { return completion(false) }
            self.contacts.append(contact)
            return completion(true)
        }
    }
    
    func fetchContacts(completion: @escaping (Result <String, NetworkError> ) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactStrings.recordTypeKey, predicate: predicate)
        var operation = CKQueryOperation(query: query)
        
        var fetchedContacts: [Contact] = []
        
        operation.recordMatchedBlock = { _, result in
            
            switch result {
            case .success(let record):
                guard let contact = Contact(ckRecord: record) else { return completion(.failure(.unableToDecode)) }
                fetchedContacts.append(contact)
            case .failure(let error):
                return completion(.failure(.ckError(error)))
            }
            
        }
        
        operation.queryResultBlock = { result in
            switch result {
                
            case .success(let cursor):
                if let cursor = cursor {
                    
                    let nextOperation = CKQueryOperation(cursor: cursor)
                    nextOperation.queryResultBlock = operation.queryResultBlock
                    nextOperation.recordMatchedBlock = operation.recordMatchedBlock
                    
                    operation = nextOperation
                    self.privateDB.add(nextOperation)
                    
                } else {
                    self.contacts = fetchedContacts
                    return completion(.success("Success"))
                }
            case .failure(let error):
                return completion(.failure(.ckError(error)))
            }
        }
        
        privateDB.add(operation)
    }
    
    // Update
    func updateContact(_ contact: Contact, completion: @escaping(Bool) -> Void) {
        
        // Defind the record(s) to be updated
        let record = CKRecord(contact: contact)
        let operation = CKModifyRecordsOperation(recordsToSave: [record])
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInitiated
        operation.modifyRecordsResultBlock = { result in
            
            switch result {
            case .success():
                return completion(true)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                return completion(false)
            }
        }
        
        
        // Step 1 - Add the operation so the database can run it
        privateDB.add(operation)
    }
    
    // Delete
    func deleteContact(_ contact: Contact, completion: @escaping(Bool) -> Void) {
        
        // Step 2 - Declare operation
        let operation = CKModifyRecordsOperation(recordIDsToDelete: [contact.recordID])
        
        // Step 3 - Set the properties of the operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInitiated
        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success():
                return completion(true)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                return completion(false)
            }
        }
        
        // Step 1 - Add the operation so the database can run it
        privateDB.add(operation)
    }
}
