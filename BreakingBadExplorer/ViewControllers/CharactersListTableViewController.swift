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

    override func viewDidLoad() {
        super.viewDidLoad()

		let nib = UINib(nibName: Constants.characterTableViewCell, bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: Constants.reuseId)

		viewModel.loadCharacters()

		title = viewModel.title
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

extension CharactersListTableViewController: CharactersListViewModelDelegate {

	func loadCharactersSucceeded() {
		tableView.reloadData()
	}

	func loadCharactersFailed(with message: String) {
		// Show alert
	}
}

extension CharactersListTableViewController: UITableViewDataSourcePrefetching {

	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		viewModel.prefetchImages(for: indexPaths)
	}
}
