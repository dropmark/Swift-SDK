//
//  URLSession+Combine.swift
//  Pods
//
//  Created by Alex Givens on 6/23/22.
//

import Foundation
import Combine

enum HTTPError: Error {
    case response(HTTPURLResponse)
}

extension URLSession {

    /// Function that wraps the existing dataTaskPublisher method and attempts to decode the result and publish it
    /// - Parameter url: The URL to be retrieved.
    /// - Returns: Publisher that sends a DecodedResult if the response can be decoded correctly.
    func dataTaskPublisher<T: Decodable>(for urlRequest: URLRequest) -> AnyPublisher<T, Error> {
        
        return self.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data, response) -> Data in
                if
                    let response = response as? HTTPURLResponse,
                    (200..<300).contains(response.statusCode) == false
                {
                    throw HTTPError.response(response)
                }

                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}

//enum HTTPError: LocalizedError {
//    case statusCode
//}
//
//self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
//.tryMap { output in
//    guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
//        throw HTTPError.statusCode
//    }
//    return output.data
//}
//.decode(type: [Post].self, decoder: JSONDecoder())
//.eraseToAnyPublisher()
//.sink(receiveCompletion: { completion in
//    switch completion {
//    case .finished:
//        break
//    case .failure(let error):
//        fatalError(error.localizedDescription)
//    }
//}, receiveValue: { posts in
//    print(posts.count)
//})
