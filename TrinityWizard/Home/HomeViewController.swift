//
//  HomeViewController.swift
//  TrinityWizard
//
//  Created by Iskandar Herputra Wahidiyat on 03/07/23.
//

import UIKit



class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var addContactButton: UIBarButtonItem!
    
    private var contactData: [ContactModel] = []
    private let refreshControl = UIRefreshControl()
    
    private var searchResults: [ContactModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        getDataFromJSON()
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "ContactCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ContactCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func getDataFromJSON() {
        guard let fileURL = Bundle.main.url(forResource: "data", withExtension: "json") else {
            print("JSON file not found.")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let jsonArray = json as? [[String: Any]] {
                var items: [ContactModel] = []
                for item in jsonArray {
                    let id = item["id"] as? String
                    let firstName = item["firstName"] as? String
                    let lastName = item["lastName"] as? String
                    let email = item["email"] as? String
                    let dob = item["dob"] as? String
                    let contactDataModel = ContactModel(id: id ?? "", firstName: firstName ?? "", lastName: lastName ?? "", email: email ?? "", dob: dob ?? "")
                    items.append(contactDataModel)
                }
                self.contactData = items
                self.searchResults = self.contactData
                collectionView.reloadData()
            } else {
                print("Invalid JSON format.")
            }
        } catch {
            print("Error reading JSON file: \(error)")
        }
    }
    
    func showAlertWithTextField() {
        let alertController = UIAlertController(title: "Search Contact", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Search Contact"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Search", style: .default) { [weak self] action in
            guard let textField = alertController.textFields?.first,
                  let enteredText = textField.text else {
                return
            }
            self?.processEnteredText(enteredText)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func processEnteredText(_ text: String) {
        let filteredByFirstName = contactData.filter { person in
            let firstName = person.firstName.lowercased()
            let lastName = person.lastName.lowercased()
            let fullName = "\(firstName) \(lastName)"
            return fullName.lowercased().contains(text.lowercased())
        }
        searchResults = filteredByFirstName
        
        collectionView.reloadData()
    }
    
    @objc private func refreshData() {
        contactData = []
        searchResults = []
        getDataFromJSON()
        refreshControl.endRefreshing()
    }
    
    @objc private func searchButtonDidTapped() {
        showAlertWithTextField()
    }
    
    @objc private func addContactButtonDidTapped() {
        let vc = ContactDetailViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTappedSearchButton(_ sender: UIBarButtonItem) {
        searchButtonDidTapped()
    }
    
    @IBAction func didTappedAddContactButton(_ sender: UIBarButtonItem) {
        addContactButtonDidTapped()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ContactDetailViewController()
        vc.delegate = self
        vc.contactDetail = searchResults[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCollectionViewCell", for: indexPath) as? ContactCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.contactNameLabel.text = "\(searchResults[indexPath.row].firstName) \(searchResults[indexPath.row].lastName)"
        return cell
    }
}

extension HomeViewController: ContactDetailDelegate {
    func saveButtonTapped(data: ContactModel) {
        searchResults.append(data)
        
        for (index, item) in searchResults.enumerated() {
            if item.id == data.id {
                searchResults.remove(at: index)
                break
            }
        }
        collectionView.reloadData()
    }
}
