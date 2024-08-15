//
//  FavouriteViewModel.swift
//  MVVM-Architecture
//
//  Created by russel on 15/8/24.
//

import Foundation
import Combine

class FavouriteViewModel {
    var favouriteStorageService: FavouriteStorageService
    
    @Published var detailData = [PokemonDetailModel]()
    
    init(favouriteStorageService: FavouriteStorageService = DefaultFavouriteStorageService()) {
        self.favouriteStorageService = favouriteStorageService
        
        getAllFavourites()
    }
    
    func getAllFavourites() {
        let allData = favouriteStorageService.getAllFavourites()
        detailData = allData
    }
    
    func deleteFavourite(data: PokemonDetailModel) {
        favouriteStorageService.delete(data: data)
    }
}
