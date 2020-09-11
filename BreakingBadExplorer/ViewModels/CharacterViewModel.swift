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

	let character: Character

	init(character: Character) {
		name = character.name
		imageURL = URL(string: character.img)
		appearance = character.appearance

		self.character = character
	}
}
