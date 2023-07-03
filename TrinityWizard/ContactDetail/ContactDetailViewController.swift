//
//  ContactDetailViewController.swift
//  TrinityWizard
//
//  Created by Iskandar Herputra Wahidiyat on 03/07/23.
//

import UIKit

enum FlowType: String {
    case edit
    case add
}

protocol ContactDetailDelegate: AnyObject {
    func saveButtonTapped(data: ContactModel)
}

class ContactDetailViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var mainInformationTitleLabel: UILabel!
    @IBOutlet weak var firstNameTitleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTitleLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var subInformationTitleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dobTitleLabel: UILabel!
    @IBOutlet weak var dobTextField: UITextField!
    
    weak var delegate: ContactDetailDelegate?
    var contactDetail: ContactModel?
    
    private var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarIcon = UIImage(systemName: "calendar")
        let tintedCalendarIcon = calendarIcon?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let rightIconView = UIImageView(image: tintedCalendarIcon)
    
        dobTextField.rightView = rightIconView
        dobTextField.rightViewMode = .always
        
        firstNameTextField.text = contactDetail?.firstName
        lastNameTextField.text = contactDetail?.lastName
        emailTextField.text = contactDetail?.email
        dobTextField.text = contactDetail?.dob
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dobTextField.inputView = datePicker
    }
    
    @objc private func cancelButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonDidTapped() {
        if firstNameTextField.text != "" && lastNameTextField.text != "" {
            let contactData = ContactModel(id: contactDetail?.id ?? "", firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", email: emailTextField.text ?? "", dob: dobTextField.text ?? "")
            delegate?.saveButtonTapped(data: contactData)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func datePickerValueChanged() {
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dobTextField.text = dateFormatter.string(from: selectedDate)
    }
    
    @IBAction func didTappedCancelButton(_ sender: UIBarButtonItem) {
        cancelButtonDidTapped()
    }
    
    @IBAction func didTappedSaveButton(_ sender: UIBarButtonItem) {
        saveButtonDidTapped()
    }
}
