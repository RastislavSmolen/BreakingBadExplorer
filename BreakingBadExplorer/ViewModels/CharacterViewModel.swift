//
//  CharacterViewModel.swift
//  BreakingBadExplorer
//
//  Created by Rastislav Smolen on 10/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import Foundation

struct CharacterViewModel {

	let name: String
	let imageURL: URL?
	let appearance: [Season]
	let appearanceString: String
	let occupation: [String]
	let occupationString: String
	let nickname: String
	let status: String

	let character: Character

	init(character: Character) {
		name = character.name
		imageURL = URL(string: character.img)
		appearance = character.appearance
		appearanceString = appearance
			.compactMap { "\($0)".capitalized }
			.joined(separator: "\n")
		occupation = character.occupation
		occupationString = occupation.joined(separator: "\n")
		nickname = character.nickname
		status =  character.status

		self.character = character
	}
}
