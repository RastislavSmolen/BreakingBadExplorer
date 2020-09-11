//
//  CharacterViewModelTests.swift
//  BreakingBadExplorerTests
//
//  Created by Rastislav Smolen on 11/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import XCTest
@testable import BreakingBadExplorer

class CharacterViewModelTests: XCTestCase {

	private var sut: CharacterViewModel!

    override func tearDownWithError() throws {
        sut = nil
    }

	func test_WhenInitialised_ThenHasCorrectValues() {
		// given & when
		sut = CharacterViewModel(character: Character(id: 1, name: "Walter White", img: "", appearance: [.one, .two, .three], occupation: [ "O1", "O2" ], status: "Alive", nickname: "Nickname"))

		// then
		XCTAssertEqual(sut.name, "Walter White")
		XCTAssertNil(sut.imageURL)
		XCTAssertEqual(sut.appearance, [.one, .two, .three])
		XCTAssertEqual(sut.appearanceString, "One\nTwo\nThree")
		XCTAssertEqual(sut.occupation,["O1", "O2"])
		XCTAssertEqual(sut.occupationString, "O1\nO2")
		XCTAssertEqual(sut.nickname, "Nickname")
		XCTAssertEqual(sut.status, "Alive")
	}
}
