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
}

class CharactersListViewModel {

	private let delegate: CharactersListViewModelDelegate
	private(set) var viewModels: [CharacterViewModel]
	private let networkManager: NetworkManager

	init(delegate: CharactersListViewModelDelegate, viewModels: [CharacterViewModel] = [], networkManager: NetworkManager = .init()) {
		self.delegate = delegate
		self.viewModels = viewModels
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
		
	}
}
