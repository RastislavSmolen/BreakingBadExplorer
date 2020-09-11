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

    override func setUpWithError() throws {
		mockNetworkManager = MockNetworkManager()
		delegateStub = DelegateStub()
		sut = CharactersListViewModel(delegate: delegateStub, networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
		mockNetworkManager = nil
		delegateStub = nil
		sut = nil
    }

	func test_WhenLoadCharactersIsCalled_ThenCharactersAreLoaded() {
		// given
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


}

class MockNetworkManager: NetworkManager {

	var shouldSucceed = true

	override func getCharacters(_ completion: @escaping (Result<[Character], APIError>) -> Void) {
		if shouldSucceed {
			let characters = try! JSONDecoder().decode([Character].self, from: MockedData.getCharactersSuccessJSON)
			completion(.success(characters))
		} else {
			completion(.failure(.failed(message: "Unexpected error occured")))
		}
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
