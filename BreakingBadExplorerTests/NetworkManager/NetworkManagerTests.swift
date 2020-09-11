//
//  NetworkManagerTests.swift
//  BreakingBadExplorerTests
//
//  Created by Rastislav Smolen on 10/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import XCTest
@testable import BreakingBadExplorer
import Alamofire
import Mocker

class NetworkManagerTests: XCTestCase {

	private var sut: NetworkManager!

    override func setUpWithError() throws {
		let configuration = URLSessionConfiguration.af.default
		configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
		let session = Session(configuration: configuration)

		sut = NetworkManager(session: session)
    }

    override func tearDownWithError() throws {
		sut = nil
    }

	func test_WhenCharactersAPICalled_ThenListIsRetrieved() {
		// given
		let mock = Mock(url: Endpoint.characters.url, dataType: .json, statusCode: 200, data: [
			.get: MockedData.getCharactersSuccessJSON
		])
		mock.register()

		let exp = expectation(description: "Waiting for Characters API response")

		// when
		sut.getCharacters { result in
			// then
			switch result {
			case .success(let characters): XCTAssertEqual(characters.count, 63)
			case .failure(let error): XCTFail(error.localizedDescription)
			}
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1)
	}

	func test_WhenCharactersAPICalled_ThenErrorIsThrown() {
		// given
		let mock = Mock(url: Endpoint.characters.url, dataType: .json, statusCode: 429, data: [
			.get: Data()
		])
		mock.register()

		let exp = expectation(description: "Waiting for Characters API response")

		// when
		sut.getCharacters { result in
			// then
			switch result {
			case .success: XCTFail("This API response is supposed to fail")
			case .failure(let error): print(error)
			}
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1)
	}

	func test_WhenPrefetchImagesIsCalled_ThenImageIsDownloaded() {
		// given
		let url = URL(string: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg")!
		let mock = Mock(url: url, dataType: .imagePNG, statusCode: 200, data: [
			.get: MockedData.walterWhiteImage
		])
		mock.register()

		let exp = expectation(description: "Waiting to download image")

		// when
		sut.prefetch(urls: [url]) {
			// then
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1)
	}
}
