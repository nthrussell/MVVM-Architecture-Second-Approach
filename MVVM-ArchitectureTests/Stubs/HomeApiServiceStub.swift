//
//  HomeApiServiceStub.swift
//  MVVM-Architecture
//
//  Created by russel on 15/8/24.
//

import XCTest
import Combine

@testable import MVVM_Architecture

class HomeApiServiceStub: HomeApiService {
    private let result: Result<PokemonListModel, Error>
    private(set) var callCount = 0

    init(returning result: Result<PokemonListModel, Error>) {
        self.result = result
    }
    
    func fetchPokemonList(offset: Int) -> AnyPublisher<PokemonListModel, Error> {
        callCount += 1
        return result.publisher
            .delay(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
