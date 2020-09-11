//
//  CharactersListViewModel.swift
//  BreakingBadExplorer
//
//  Created by Rastislav Smolen on 10/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import Foundation

protocol CharactersListViewModelDelegate {
	func loadCharactersSucceeded()
	func loadCharactersFailed(with message: String)
	func searchResultsUpdated()
}

class CharactersListViewModel {

	let title = "Characters"

	private let delegate: CharactersListViewModelDelegate
	private var masterViewModels: [CharacterViewModel]
	private(set) var viewModels: [CharacterViewModel]
	private let networkManager: NetworkManager

	init(delegate: CharactersListViewModelDelegate, viewModels: [CharacterViewModel] = [], networkManager: NetworkManager = .init()) {
		self.delegate = delegate
		self.viewModels = viewModels
		masterViewModels = viewModels
		self.networkManager = networkManager
	}

	subscript(indexPath: IndexPath) -> CharacterViewModel {
		self.viewModels[indexPath.item]
	}

	func loadCharacters() {
		networkManager.getCharacters { (result) in
			switch result {
			case .success(let characters):
				self.viewModels = characters.map { CharacterViewModel(character: $0) }
				self.delegate.loadCharactersSucceeded()
			case .failure(let error):
				self.delegate.loadCharactersFailed(with: error.localizedDescription)
			}
		}
	}

	func prefetchImages(for indexPaths: [IndexPath]) {
		let urls = indexPaths
			.map { self[$0].character.img }
			.compactMap { URL(string: $0) }
		networkManager.prefetch(urls: urls)
	}

	func search(text: String?) {
		func informDelegate() {
			DispatchQueue.main.async {
				self.delegate.searchResultsUpdated()
			}
		}

		DispatchQueue.global(qos: .background).async {
			guard let text = text?.lowercased(), text.count > 0 else {
				self.viewModels = self.masterViewModels
				return informDelegate()
			}
			self.viewModels = self.masterViewModels.filter { $0.name.lowercased().contains(text) }
			informDelegate()
		}
	}
}
