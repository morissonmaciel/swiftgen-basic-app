//
//  SourcesViewController.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 09/01/23.
//

import UIKit

final class SourcesViewController: UITableViewController {
    var sources = [
        "business", "entertainment", "general", "health", "science", "sports", "technology"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        updateContents()
    }
    
    private func prepareTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func updateContents() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = sources[indexPath.row]
        cell.textLabel?.text = item.localizedCapitalized
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = sources[indexPath.row]
        let headlinesVC = HeadlinesViewController()
        headlinesVC.category = selectedCategory
        headlinesVC.title = selectedCategory.localizedCapitalized
        
        navigationController?.pushViewController(headlinesVC, animated: true)
    }
}
