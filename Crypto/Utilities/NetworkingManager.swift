//
//  NetworkingManager.swift
//  Crypto
//
//  Created by iCommunity app on 11/08/2024.
//

import Foundation
import Combine

actor NetworkingManager {
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var localizedDescription: String? {
            switch self {
            case .badURLResponse(let url): return "[🔥] Bad response from URL \(url)"
            case .unknown: return "[⚠️] Unknown error occurred."
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { try handleResponse(url: url, output: $0) }
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    private static func handleResponse(url: URL, output: URLSession.DataTaskPublisher.Output) throws -> Data {
//        throw NetworkingError.badURLResponse(url: url)
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished: break
        case .failure(let error): print("Failure error: ", error)
        }
    }
}
