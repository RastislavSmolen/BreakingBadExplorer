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
		let text = "white"
		let exp = expectation(description: "Waiting for search results")

		initialiseSUT(viewModels: getMockCharacters())

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
		let exp = expectation(description: "Waiting for search results")

		initialiseSUT(viewModels: getMockCharacters())

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
		let exp = expectation(description: "Waiting for search results")

		initialiseSUT(viewModels: getMockCharacters())

		delegateStub.didCallSearchResultsUpdated = {
			// then
			XCTAssertEqual(self.sut.viewModels.count, 63)
			exp.fulfill()
		}

		// when
		sut.search(text: nil)

		wait(for: [exp], timeout: 1)
	}

	func test_WhenAllSeasonFilterIsApplied_ThenCorrectResultsReturned() {
		// given
		let exp = expectation(description: "Waiting for search results")

		initialiseSUT(viewModels: getMockCharacters())

		delegateStub.didCallSearchResultsUpdated = {
			// then
			XCTAssertEqual(self.sut.viewModels.count, 63)
			exp.fulfill()
		}

		// when
		sut.search(text: nil, in: .all)

		wait(for: [exp], timeout: 1)
	}

	func test_WhenSeasonTwoFilterIsApplied_ThenCorrectResultsReturned() {
		// given
		let exp = expectation(description: "Waiting for search results")

		initialiseSUT(viewModels: getMockCharacters())

		delegateStub.didCallSearchResultsUpdated = {
			// then
			XCTAssertEqual(self.sut.viewModels.count, 36)
			exp.fulfill()
		}

		// when
		sut.search(text: nil, in: .two)

		wait(for: [exp], timeout: 1)
	}

	func test_WhenSearchTextWithSeasonOneFilterIsApplied_ThenCorrectResultsReturned() {
		let exp = expectation(description: "Waiting for search results")
		let text = "White"
		initialiseSUT(viewModels: getMockCharacters())

		delegateStub.didCallSearchResultsUpdated = {
			// then
			XCTAssertEqual(self.sut.viewModels.count, 3)
			exp.fulfill()
		}

		// when
		sut.search(text: text, in: .one)

		wait(for: [exp], timeout: 1)
	}
}
