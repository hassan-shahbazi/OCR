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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadHistory()
    }
    
    private func loadHistory() {
        history = viewModel.getHistory()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
