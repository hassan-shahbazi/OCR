//
//  ShowCardInformationViewController.swift
//  CardScanner
//
//  Created by Hassan Shahbazi on 12/5/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit

class ShowCardInformationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    public var item: HistoryObject!
    private var extractedItems: [String?] = []
    private var sectionHeaders: [String] {
        return ["Images", "Surname", "First Name", "Surname at Birth", "ID Number", "Date of Birth", "Gender", "Signature", "Nationality", "registration date"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extractItems()
    }
    
    private func extractItems() {
        extractedItems = []
        extractedItems.insert(item.person?.sureName, at: 0)
        extractedItems.insert(item.person?.firstName, at: 1)
        extractedItems.insert(item.person?.sureNameBirthDate, at: 2)
        extractedItems.insert(item.person?.idNumber, at: 3)
        extractedItems.insert(Utility.getString(from: item.person?.birthdate ?? Date()), at: 4)
        extractedItems.insert(item.person?.gender?.description, at: 5)
        extractedItems.insert(item.person?.signature, at: 6)
        extractedItems.insert(item.person?.nationality, at: 7)
        extractedItems.insert(Utility.getString(from: item.date ?? Date()), at: 8)
    }
}

extension ShowCardInformationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0, let cell = tableView.dequeueReusableCell(withIdentifier: "image_cell") as? ShowInfoImageTableViewCell {
            
            cell.setup(item)
            return cell
        }
        if indexPath.section > 0, let cell = tableView.dequeueReusableCell(withIdentifier: "info_cell") {
            cell.textLabel?.text = extractedItems[indexPath.section - 1] ?? ""
            return cell
        }
        return UITableViewCell()
    }
}

extension ShowCardInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ? 128 : 44
    }
}
