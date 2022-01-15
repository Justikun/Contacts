//
//  AddContactViewController.swift
//  Contacts
//
//  Created by Justin Lowry on 1/14/22.
//

import UIKit

class AddContactViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - Properties
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        updateViews()
    }
    // MARK: - Actions
    @IBAction func saveTapped(_ sender: Any) {
        checkRequiredFields()
        saveContact()
    }
    
    // MARK: - Methods
    func saveContact() {
        guard let name = nameTextField.text,
              !name.isEmpty
        else { return }
        
        let phoneNumber = phoneNumberTextField.text
        let email = emailTextField.text
        
        if let contact = contact {
            contact.name = name
            contact.phoneNumber = phoneNumber
            contact.email = email
            ContactController.shared.updateContact(contact) { _ in }
        } else {
            ContactController.shared.createContact(name: name, phoneNumber: phoneNumber, email: email) { _ in }
        }
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func checkRequiredFields() {
        guard let nameText = nameTextField.text
        else { return }
        
        if nameText.isEmpty {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func updateViews() {
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        phoneNumberTextField.text = contact.phoneNumber
        emailTextField
            .text = contact.name
    }
}

extension AddContactViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            checkRequiredFields()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
