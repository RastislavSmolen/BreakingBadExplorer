//
//  Character.swift
//  BreakingBadExplorer
//
//  Created by Rastislav Smolen on 10/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import Foundation

enum Season: Int, Decodable {
	case one = 1
	case two = 2
	case three = 3
	case four = 4
	case five = 5
}

struct Character: Decodable {
	let name: String
	let img: String
	let appearance: [Season]
}
