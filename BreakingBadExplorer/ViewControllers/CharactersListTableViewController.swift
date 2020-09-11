//
//  CharactersListTableViewController.swift
//  BreakingBadExplorer
//
//  Created by Rastislav Smolen on 10/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import UIKit

class CharactersListTableViewController: UITableViewController {

	private struct Constants {
		static let characterTableViewCell = "CharacterTableViewCell"
		static let reuseId = "reuseId"
	}

	private lazy var viewModel = CharactersListViewModel(delegate: self)
	private lazy var searchController = UISearchController(searchResultsController: nil)

	override func viewDidLoad() {
		super.viewDidLoad()

		let nib = UINib(nibName: Constants.characterTableViewCell, bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: Constants.reuseId)

		viewModel.loadCharacters()
		setupSearchBar()
		title = viewModel.title
	}

	private func setupSearchBar() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Characters"
		searchController.automaticallyShowsCancelButton = true
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}

	// MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.viewModels.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseId, for: indexPath) as! CharacterTableViewCell
		cell.set(viewModel[indexPath])
		return cell
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

	}
}

extension CharactersListTableViewController: UITableViewDataSourcePrefetching {

	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		viewModel.prefetchImages(for: indexPaths)
	}
}

extension CharactersListTableViewController: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		viewModel.search(text: searchController.searchBar.text, in: nil)
	}
}

extension CharactersListTableViewController: CharactersListViewModelDelegate {

	func loadCharactersSucceeded() {
		tableView.reloadData()
	}

	func loadCharactersFailed(with message: String) {
		// Show alert
	}

	func searchResultsUpdated() {
		tableView.reloadData()
	}
}
