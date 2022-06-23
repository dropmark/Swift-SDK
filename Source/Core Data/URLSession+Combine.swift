//
//  URLSession+Combine.swift
//  Pods
//
//  Created by Alex Givens on 6/23/22.
//

import Foundation
import Combine

extension URLSession {

    // 1
    enum SessionError: Error {
        case statusCode(HTTPURLResponse)
    }

    /// Function that wraps the existing dataTaskPublisher method and attempts to decode the result and publish it
    /// - Parameter url: The URL to be retrieved.
    /// - Returns: Publisher that sends a DecodedResult if the response can be decoded correctly.
    // 2
    func dataTaskPublisher<T: Decodable>(for url: URL) -> AnyPublisher<T, Error> {
        // 3
        return self.dataTaskPublisher(for: url)
            // 4
            .tryMap({ (data, response) -> Data in
                if let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode) == false {
                    throw SessionError.statusCode(response)
                }

                return data
            })
            // 5
            .decode(type: T.self, decoder: JSONDecoder())
            // 6
            .eraseToAnyPublisher()
    }
}
