//
//  EmailCell.swift
//  Email Note
//
//  Created by Blake Gordon on 7/15/19.
//  Copyright © 2019 Blake Gordon. All rights reserved.
//

import UIKit

class EmailCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var validateSpinner: UIActivityIndicatorView!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var clearButtonWidth: NSLayoutConstraint!
    
    weak var viewController: SettingsTableViewController?
    var row: Int?
    
    @IBAction func emailValueChanged(_ sender: Any) {
        spinner(animate: false)
        if let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            Comparison.containsCaseInsensitive(email, User.emailsValidated) && email != "" {
            validateButton.isEnabled = true
            validateButton.isUserInteractionEnabled = false
            validateButton.tintColor = .green
        } else {
            validateButton.isEnabled = false
        }
    }
    
    @IBAction func setEmail(_ sender: Any) {
        if let view = viewController, let index = row,
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            email != "" {
            view.emails[index] = email
            checkEmail()
        }
    }
    
    @IBAction func validateEmail(_ sender: Any) {
        spinner(animate: true)
        if let index = row, let emails = viewController?.emails, index < emails.count {
            User.validateRequest(email: User.mainEmail) { error in
                if error == nil {
                    self.viewController?.presentAlert(title: "Request Sent", message: "Email validation request sent!")
                } else {
                    self.unableToSendVerificationEmailAlert()
                }
                self.spinner(animate: false)
            }
        } else {
            unableToSendVerificationEmailAlert()
            spinner(animate: false)
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        viewController?.view.endEditing(true)
        if let index = row {
            viewController?.emails.remove(at: index)
            viewController?.tableView.reloadData()
        }
    }
    
    func populateCell(row: Int, viewController: SettingsTableViewController) {
        self.viewController = viewController
        self.row = row
        
        emailField.text = viewController.emails[row]
        clearButton.isHidden = viewController.emails.count == 1
        
        emailField.delegate = self
        
        validateSpinner.style = .medium
        clearButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        clearButtonWidth.constant = (clearButton.isHidden) ? 0 : 22
        
        checkEmail()
    }
    
    func checkEmail() {
        if let email = viewController?.emails[row ?? 0] {
            spinner(animate: true)
            User.isEmailValidated(email) { (validEmail, verificationEmail) in
                self.spinner(animate: false)
                self.validateButton.isEnabled = true
                if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                    self.validateButton.isEnabled = false
                } else if let valid = validEmail {
                    if valid {
                        self.validateButton.isUserInteractionEnabled = false
                        self.validateButton.tintColor = .green
                    } else {
                        self.validateButton.isUserInteractionEnabled = true
                        self.validateButton.tintColor = .orange
                        if let emailSent = verificationEmail, emailSent {
                            self.viewController?.presentAlert(title: "Request Sent",
                                                              message: "Email validation request sent for this new email!")
                        } else if verificationEmail != nil {
                            self.unableToSendVerificationEmailAlert()
                        }
                    }
                } else {
                    self.validateButton.isUserInteractionEnabled = false
                    self.validateButton.tintColor = .red
                    self.viewController?.presentAlert(title: "Invalid Email",
                                                      message: "Please enter a valid email address")
                }
            }
        }
    }
    
    private func spinner(animate: Bool) {
        validateButton.isHidden = animate
        (animate) ? validateSpinner.startAnimating() : validateSpinner.stopAnimating()
        validateSpinner.isHidden = !animate
    }
    
    private func unableToSendVerificationEmailAlert() {
        self.viewController?.presentAlert(title: "Hmm",
                                          message: "There seems to be an issue sending the verification email. Please try again later.")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewController?.view.endEditing(true)
        return false
    }
}
