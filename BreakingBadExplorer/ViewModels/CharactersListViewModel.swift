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
	var seasonTitles: [String] {
		Season.allCases.map { $0.shortHand }
	}

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
		viewModels[indexPath.item]
	}

	func loadCharacters() {
		networkManager.getCharacters { (result) in
			switch result {
			case .success(let characters):
				self.masterViewModels = characters.map { CharacterViewModel(character: $0) }
				self.viewModels = self.masterViewModels
				self.delegate.loadCharactersSucceeded()
			case .failure(let error):
				self.delegate.loadCharactersFailed(with: error.localizedDescription)
			}
		}
	}

	func prefetchImages(for indexPaths: [IndexPath]) {
		let urls = indexPaths.compactMap { self[$0].imageURL }
		networkManager.prefetch(urls: urls)
	}

	func search(text: String?, in season: Season? = nil) {
		func informDelegateOnMainThread() {
			DispatchQueue.main.async {
				self.delegate.searchResultsUpdated()
			}
		}

		DispatchQueue.global(qos: .background).async {
			if (text == nil || text?.count == 0) && season == nil {
				self.viewModels = self.masterViewModels
				return informDelegateOnMainThread()
			}

			self.viewModels = self.masterViewModels.filter { (viewModel) -> Bool in
				/*
				If text is available then apply it's filter
				If season is available then apply it's filter
				If both are available then apply both filters
				*/

				var nameMatched = true
				if let text = text?.lowercased(), text.count > 0 {
					nameMatched = viewModel.name.lowercased().contains(text)
				}

				var seasonMatched = true
				if let season = season, season != .all {
					seasonMatched = viewModel.appearance.contains(season)
				}

				return nameMatched && seasonMatched
			}
			informDelegateOnMainThread()
		}
	}
}
