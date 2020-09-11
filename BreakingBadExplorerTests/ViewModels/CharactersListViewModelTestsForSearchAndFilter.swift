//
//  CharactersListViewModelTestsForSearchAndFilter.swift
//  BreakingBadExplorerTests
//
//  Created by Rastislav Smolen on 11/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import XCTest
@testable import BreakingBadExplorer

extension CharactersListViewModelTests {

	/*
	Search use cases
	1. Text
	2. Season filter
	3. Text and Season filter
	*/

	func test_WhenSearchWithText_ThenCorrectCaseInsensitiveResultsReturned() {
		// given
		let characters = try! JSONDecoder()
			.decode([Character].self, from: MockedData.getCharactersSuccessJSON)
			.map { CharacterViewModel(character: $0) }
		let text = "white"
		let exp = expectation(description: "Waiting for search results")

		initialiseSUT(viewModels: characters)

		delegateStub.didCallSearchResultsUpdated = {
			// then
			let results = self.sut.viewModels
			XCTAssertEqual(results.count, 4)
			XCTAssertEqual(results[0].name, "Walter White")
			XCTAssertEqual(results[1].name, "Skyler White")
			XCTAssertEqual(results[2].name, "Walter White Jr.")
			XCTAssertEqual(results[3].name, "Holly White")

			exp.fulfill()
		}

		// when
		sut.search(text: text)

		wait(for: [exp], timeout: 1)
	}

	func test_WhenSearchWithEmptyText_ThenAllResultsReturned() {
		// given
		let characters = try! JSONDecoder()
			.decode([Character].self, from: MockedData.getCharactersSuccessJSON)
			.map { CharacterViewModel(character: $0) }
		let exp = expectation(description: "Waiting for search results")

		initialiseSUT(viewModels: characters)

		delegateStub.didCallSearchResultsUpdated = {
			// then
			XCTAssertEqual(self.sut.viewModels.count, 63)
			exp.fulfill()
		}

		// when
		sut.search(text: "")

		wait(for: [exp], timeout: 1)
	}

	func test_WhenSearchWithNilText_ThenAllResultsReturned() {
		// given
		let characters = try! JSONDecoder()
			.decode([Character].self, from: MockedData.getCharactersSuccessJSON)
			.map { CharacterViewModel(character: $0) }
		let exp = expectation(description: "Waiting for search results")

		initialiseSUT(viewModels: characters)

		delegateStub.didCallSearchResultsUpdated = {
			// then
			XCTAssertEqual(self.sut.viewModels.count, 63)
			exp.fulfill()
		}

		// when
		sut.search(text: nil)

		wait(for: [exp], timeout: 1)
	}

	func test_WhenSeasonFilterIsApplied_ThenCorrectResultsReturned() {

	}

	func test_WhenSearchTextWithSeasonFilterIsApplied_ThenCorrectResultsReturned() {

	}
}
