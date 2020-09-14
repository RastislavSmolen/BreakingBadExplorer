//
//  SeasonTests.swift
//  BreakingBadExplorerTests
//
//  Created by Rastislav Smolen on 14/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import XCTest
@testable import BrBa

class SeasonTests: XCTestCase {

	func test_AlwaysHaveCorrectShortHands() {
		// then
		XCTAssertEqual(Season.all.shortHand, "All")
		XCTAssertEqual(Season.one.shortHand, "S1")
		XCTAssertEqual(Season.two.shortHand, "S2")
		XCTAssertEqual(Season.three.shortHand, "S3")
		XCTAssertEqual(Season.four.shortHand, "S4")
		XCTAssertEqual(Season.five.shortHand, "S5")
	}
}
