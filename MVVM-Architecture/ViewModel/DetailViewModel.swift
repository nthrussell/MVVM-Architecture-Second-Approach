//
//  DetailViewModel.swift
//  MVVM-Architecture
//
//  Created by russel on 15/8/24.
//

import Foundation
import Combine

class DetailViewModel {
    var url: String
    var detailApiService: DetailApiService
    var detailStorageService: DetailStorageService
    
    @Published var data: PokemonDetailModel?
    var cancellable = Set<AnyCancellable>()
        
    init(url: String,
         detailApiService: DetailApiService = DefaultDetailApiService(),
         detailStorageService: DetailStorageService = DefaultDetailStorageService()
    ) {
        self.url = url
        self.detailApiService = detailApiService
        self.detailStorageService = detailStorageService
        
        callApi()
    }
    
    func callApi() {
        detailApiService
            .fetchDetail(with: url)
            .receive(on: DispatchQueue.main)
            .sink { status in
                debugPrint("status is:\(status)")
            } receiveValue: { [weak self] payload in
                guard let self = self else { return }
                data = payload
                Loader.hide()
            }
            .store(in: &cancellable)
    }
    
    func checkIfFavourite(data: PokemonDetailModel) -> Bool {
        let data = detailStorageService.checkIfFavourite(data: data)
        return data
    }
    
    func saveOrDelete(data: PokemonDetailModel) {
        detailStorageService.saveOrDelete(with: data)
    }
}
