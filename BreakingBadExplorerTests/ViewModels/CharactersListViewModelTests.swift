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

	private var sut: CharactersListViewModel!
	private var delegateStub: DelegateStub!
	private var mockNetworkManager: MockNetworkManager!

    override func tearDownWithError() throws {
		mockNetworkManager = nil
		delegateStub = nil
		sut = nil
    }

	private func initialiseSUT(viewModels: [CharacterViewModel] = []) {
		mockNetworkManager = MockNetworkManager()
		delegateStub = DelegateStub()
		sut = CharactersListViewModel(delegate: delegateStub, viewModels: viewModels, networkManager: mockNetworkManager)
	}

	private func mockViewModels() -> [CharacterViewModel] {
		[
			CharacterViewModel(character: Character(name: "Walter White", img: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg")),
			CharacterViewModel(character: Character(name: "Jesse Pinkman", img: "https://upload.wikimedia.org/wikipedia/en/thumb/f/f2/Jesse_Pinkman2.jpg/220px-Jesse_Pinkman2.jpg"))
		]
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
		initialiseSUT(viewModels: mockViewModels())

		// when
		let characterViewModel1 = sut[IndexPath(item: 0, section: 0)]
		let characterViewModel2 = sut[IndexPath(item: 1, section: 0)]

		// then
		XCTAssertEqual(characterViewModel1.name, "Walter White")
		XCTAssertEqual(characterViewModel2.name, "Jesse Pinkman")
	}

	func test_WhenPrefetchImagesIsCalled_ThenItPrefetchesImages() {
		// given
		initialiseSUT(viewModels: mockViewModels())
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

	func loadCharactersSucceeded() {
		didLoadCharactersSucceeded?()
	}

	func loadCharactersFailed(with message: String) {
		didLoadCharactersFailed?()
	}
}
