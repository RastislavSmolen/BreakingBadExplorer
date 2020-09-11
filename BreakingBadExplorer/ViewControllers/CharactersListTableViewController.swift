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
		static let searchBarPlaceholder = "Search Characters"
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
		searchController.searchBar.placeholder = Constants.searchBarPlaceholder
		searchController.automaticallyShowsCancelButton = true
		navigationItem.searchController = searchController
		definesPresentationContext = true

		searchController.searchBar.scopeButtonTitles = Season.allCases.map { "\($0)".capitalized }
		searchController.searchBar.delegate = self
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
		let season = Season(rawValue: searchController.searchBar.selectedScopeButtonIndex)
		viewModel.search(text: searchController.searchBar.text, in: season)
	}
}

extension CharactersListTableViewController: UISearchBarDelegate {

	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		let season = Season(rawValue: selectedScope)
		viewModel.search(text: searchBar.text, in: season)
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
