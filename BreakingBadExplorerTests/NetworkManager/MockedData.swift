//
//  MockedData.swift
//  BreakingBadExplorerTests
//
//  Created by Rastislav Smolen on 10/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import Foundation

final class MockedData {

	public static let getCharactersSuccessJSON = try! Data(contentsOf: Bundle(for: MockedData.self).url(forResource: "characters", withExtension: "json")!)

	public static let walterWhiteImage = try! Data(contentsOf: Bundle(for: MockedData.self).url(forResource: "Walter White", withExtension: "jpg")!)
}
