//
//  NetworkManager.swift
//  BreakingBadExplorer
//
//  Created by Rastislav Smolen on 10/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: Error {
	case failed(message: String)
}

enum Endpoint {
	case characters

	var url: URL? {
		let base = "https://breakingbadapi.com/api"
		switch self {
		case .characters: return URL(string: base + "/characters")
		}
	}
}

class NetworkManager {

	let session: Session

	init(session: Session = Session.default) {
		self.session = session
	}

	func getCharacters(_ completion: @escaping (Result<[Character], APIError>) -> Void) {
		guard let url = Endpoint.characters.url else {
			return completion(.failure(.failed(message: "Invalid URL")))
		}
		session.request(url)
			.responseDecodable(of: [Character].self) { response in
				switch response.result {
				case .success(let characters):
					completion(.success(characters))
				case .failure(let error):
					print(error)
					completion(.failure(.failed(message: error.localizedDescription)))
				}
		}
	}
}
