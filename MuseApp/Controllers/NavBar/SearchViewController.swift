//
//  SearchViewController.swift
//  MuseApp
//
//  Created by Zoe Wende on 2/20/22.
//

import UIKit

struct SearchRenderViewModel{
    let header: PostRenderViewModel
}

class SearchViewController: UIViewController {

    private var searchViewModel = [SearchRenderViewModel]()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = UIColor(named: "AppGray")
        searchBar.placeholder = "Search"
        return searchBar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedUsernameHeaderTableViewCell.self, forCellReuseIdentifier: FeedUsernameHeaderTableViewCell.identifier)
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppDarkGray")
        navigationController?.navigationBar.topItem?.titleView = searchBar
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = UIColor(named: "AppGray")
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance

        searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "AppDarkGray")

    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didCancelSearch()
        guard let text = searchBar.text, !text.isEmpty else{
            return
        }

        query(text)

    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelSearch))
    }

    @objc private func didCancelSearch(){
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }

    private func query(_ text: String){

    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

