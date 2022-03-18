//
//  ViewController.swift
//  iTunesPlaylist
//
//  Created by Alex Ch. on 18.03.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let networkService = NetworkService()
    var searchResponse: SearchResponse? = nil
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupSearchBar()
    }

    private func setupSearchBar(){
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }

    private func setupTable(){
        
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = searchResponse?.results.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = searchResponse?.results[indexPath.row]
        cell.textLabel?.text = track?.trackName
        return cell
    }
}

extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchText)"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.request(urlString: urlString) { [weak self] (result) in
                switch result{
                case .success(let searchResponse):
                    self?.searchResponse = searchResponse
                    self?.table.reloadData()
                case .failure(let error):
                    print("Ошибка ", error)
                }
            }
        })
    }
}
