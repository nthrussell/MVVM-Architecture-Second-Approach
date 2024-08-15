//
//  MockFavouriteStorageService.swift
//  MVVM-Architecture
//
//  Created by russel on 15/8/24.
//

import XCTest

@testable import MVVM_Architecture

class MockFavouriteStorageService: FavouriteStorageService {
    var storageProvider: StorageProvider
    
    required init(storageProvider: StorageProvider = StorageProvider(storeType: .inMemory)) {
        self.storageProvider = storageProvider
    }
    
    func getAllFavourites() -> [PokemonDetailModel] {
        let value: [PokemonDetail] = storageProvider.getAllData()
        return value.map { PokemonDetailModel.mapFromEntity($0) }
    }
    
    func delete(data: PokemonDetailModel) {
        storageProvider.delete(name: data.name)
    }
}
