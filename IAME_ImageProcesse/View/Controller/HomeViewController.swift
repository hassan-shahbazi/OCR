//
//  HomeViewController.swift
//  IAME_ImageProcesse
//
//  Created by Hassaniiii on 11/22/18.
//  Copyright © 2018 Hassan Shahbazi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    private let viewModel = HistoryViewModel()
    private var history: [HistoryObject]?
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initiateView()
        loadHistory()
    }
    
    private func initiateView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func loadHistory() {
        history = viewModel.getHistory()
        table.reloadData()
    }
    
    @IBAction func captureButton(_ sender: UIButton) {
        performSegue(withIdentifier: "capture", sender: self)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "history_cell") as? HistoryTableViewCell else { return UITableViewCell() }
        cell.setup(history?[indexPath.row])
        
        return cell
    }
}
