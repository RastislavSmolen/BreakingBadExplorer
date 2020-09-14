//
//  Character.swift
//  BreakingBadExplorer
//
//  Created by Rastislav Smolen on 10/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import Foundation

enum Season: Int, Decodable, CaseIterable {
	case all = 0
	case one = 1
	case two = 2
	case three = 3
	case four = 4
	case five = 5

	var shortHand: String {
		guard self != .all else { return "All" }
		return "S\(rawValue)"
	}
}

struct Character: Decodable {
	private enum CodingKeys: String, CodingKey {
		case id = "char_id"
		case name, img, appearance, occupation, status, nickname
	}

	let id: Int
	let name: String
	let img: String
	let appearance: [Season]
	let occupation: [String]
	let status: String
	let nickname: String
}
