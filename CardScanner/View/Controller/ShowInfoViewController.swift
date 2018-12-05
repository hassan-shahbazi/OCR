//
//  ShowInfoViewController.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/25/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit

class ShowInfoViewController: UIViewController {
    public var textBlocks: [String]!
    public var capturedImage: UIImage!
    public var capturedFace: UIImage!
    private var textBlocksExtracted: Dictionary<String,String> = [:]
    private var sectionHeaders: [String] {
        return ["Surname", "First Name", "Surname at Birth", "ID Number", "Date of Birth", "Gender", "Signature", "Nationality"]
    }
    private var sectionHeadersCopy: [String]!
    private let viewModel = HistoryViewModel()
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initiateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initiateView()
    }
        
    private func initiateView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    private func initiateData() {
        sectionHeadersCopy = sectionHeaders
        for counter in 0..<textBlocks.count {
            let text = textBlocks[counter]
            if let relatedSection = getRelatedSection(text) {
                let value = text.components(separatedBy: relatedSection)
                textBlocksExtracted[relatedSection.lowercased()] = value[1]
            }
            else if text.lowercased().contains("republic") {
                sectionHeadersCopy.removeAll(where: { $0 == "Nationality" })
                textBlocksExtracted["Nationality".lowercased()] = text
            }
        }
        self.table.reloadData()
    }
    
    private func getRelatedSection(_ blockText: String) -> String? {
        for section in sectionHeadersCopy {
            if blockText.contains(section) {
                sectionHeadersCopy.removeAll(where: { $0 == section })
                return section
            }
        }
        return nil
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func saveContinue(_ sender: UIButton) {
        viewModel.saveNewPerson(data: textBlocksExtracted, image: capturedImage, faceImage: capturedFace) { (succeed: Bool?) in
            if let _ = succeed {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            self.saveBtn.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.2980392157, blue: 0.2745098039, alpha: 1)
            self.saveBtn.setTitle("Save failed", for: .normal)
        }
    }
}

extension ShowInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "result_cell") else { return UITableViewCell() }
        
        let currentSection = sectionHeaders[indexPath.section].lowercased()
        cell.textLabel?.text = textBlocksExtracted[currentSection]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
}
