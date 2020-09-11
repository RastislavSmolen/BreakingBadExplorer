//
//  CharactersListViewModelTests.swift
//  BreakingBadExplorerTests
//
//  Created by Rastislav Smolen on 11/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import XCTest
@testable import BreakingBadExplorer

class CharactersListViewModelTests: XCTestCase {

	var sut: CharactersListViewModel!
	var delegateStub: DelegateStub!
	var mockNetworkManager: MockNetworkManager!

    override func tearDownWithError() throws {
		mockNetworkManager = nil
		delegateStub = nil
		sut = nil
    }

	func initialiseSUT(viewModels: [CharacterViewModel] = []) {
		mockNetworkManager = MockNetworkManager()
		delegateStub = DelegateStub()
		sut = CharactersListViewModel(delegate: delegateStub, viewModels: viewModels, networkManager: mockNetworkManager)
	}

	func getMockCharacters() -> [CharacterViewModel] {
		try! JSONDecoder()
			.decode([Character].self, from: MockedData.getCharactersSuccessJSON)
			.map { CharacterViewModel(character: $0) }
	}
	
	func test_WhenLoadCharactersIsCalled_ThenCharactersAreLoaded() {
		// given
		initialiseSUT()
		mockNetworkManager.shouldSucceed = true
		let exp = expectation(description: "Waiting for characters list")
		delegateStub.didLoadCharactersSucceeded = {
			// then
			XCTAssertEqual(self.sut.viewModels.count, 63)
			exp.fulfill()
		}

		// when
		sut.loadCharacters()

		wait(for: [exp], timeout: 1)
	}

	func test_WhenLoadCharactersIsCalled_ThenItFails() {
		// given
		initialiseSUT()
		mockNetworkManager.shouldSucceed = false
		let exp = expectation(description: "Waiting for error")
		delegateStub.didLoadCharactersFailed = {
			// then
			XCTAssertEqual(self.sut.viewModels.count, 0)
			exp.fulfill()
		}

		// when
		sut.loadCharacters()

		wait(for: [exp], timeout: 1)
	}

	func test_WhenSubscriptUsingIndexPath_ThenReturnsCorrectCharacter() {
		// given
		initialiseSUT(viewModels: getMockCharacters())

		// when
		let characterViewModel1 = sut[IndexPath(item: 0, section: 0)]
		let characterViewModel2 = sut[IndexPath(item: 1, section: 0)]

		// then
		XCTAssertEqual(characterViewModel1.name, "Walter White")
		XCTAssertEqual(characterViewModel2.name, "Jesse Pinkman")
	}

	func test_WhenPrefetchImagesIsCalled_ThenItPrefetchesImages() {
		// given
		initialiseSUT(viewModels: getMockCharacters())
		let prefetchIndexPath = IndexPath(item: 1, section: 0)

		let exp = expectation(description: "Waiting")
		mockNetworkManager.prefetchImagesCalled = { urls in
			// then
			XCTAssertEqual(urls.first, URL(string: "https://upload.wikimedia.org/wikipedia/en/thumb/f/f2/Jesse_Pinkman2.jpg/220px-Jesse_Pinkman2.jpg"))
			exp.fulfill()
		}

		// when
		sut.prefetchImages(for: [ prefetchIndexPath ])

		wait(for: [exp], timeout: 1)
	}
}

class MockNetworkManager: NetworkManager {

	var shouldSucceed = true
	var prefetchImagesCalled: (([URL]) -> Void)?

	override func getCharacters(_ completion: @escaping (Result<[Character], APIError>) -> Void) {
		if shouldSucceed {
			let characters = try! JSONDecoder().decode([Character].self, from: MockedData.getCharactersSuccessJSON)
			completion(.success(characters))
		} else {
			completion(.failure(.failed(message: "Unexpected error occured")))
		}
	}

	override func prefetch(urls: [URL], completion: (() -> Void)? = nil) {
		prefetchImagesCalled?(urls)
	}
}

class DelegateStub: CharactersListViewModelDelegate {

	var didLoadCharactersSucceeded: (() -> Void)?
	var didLoadCharactersFailed: (() -> Void)?
	var didCallSearchResultsUpdated: (() -> Void)?

	func loadCharactersSucceeded() {
		didLoadCharactersSucceeded?()
	}

	func loadCharactersFailed(with message: String) {
		didLoadCharactersFailed?()
	}

	func searchResultsUpdated() {
		didCallSearchResultsUpdated?()
	}
}
