//
//  HomeViewModel.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//
import Foundation
import Combine

class HomeViewModel {
    var homeApiService: HomeApiService
    var hasDataLoaded = false
    
    @Published var pokemonList: [PokemonList] = [PokemonList]()
    @Published var filteredData: [PokemonList] = [PokemonList]()
    @Published var searchText: String = ""
    
    var isFiltering: Bool {
        filteredData.count > 0
    }
    
    var cancellable = Set<AnyCancellable>()
    
    init(homeApiService: HomeApiService = DefaultHomeApiService()) {
        self.homeApiService = homeApiService
        
        callApi()
        search()
    }
    
    func callApi() {
        if hasDataLoaded { return }
        homeApiService.fetchPokemonList(offset: pokemonList.count)
            .sink { status in
                debugPrint("status is:\(status)")
            } receiveValue: { [weak self] payload in
                guard let self = self else { return }
                pokemonList.append(contentsOf: payload.results)
                hasDataLoaded = true
            }
            .store(in: &cancellable)
    }
    
    func fetchMoreData() {
        hasDataLoaded = false
        callApi()
    }
    
    func rowAt(indexPath: IndexPath) -> PokemonList {
        var data: PokemonList
        
        if isFiltering {
            data = filteredData[indexPath.row]
        } else {
            data = pokemonList[indexPath.row]
        }
        
        return data
    }
    
    func numberOfRowsInSection() -> Int {
        if isFiltering {
            return filteredData.count
        } else {
            return pokemonList.count
        }
    }
    
    func filterData(with textSearched: String) {
        filteredData = pokemonList.filter {
            $0.name.lowercased().contains(textSearched.lowercased().trimmingCharacters(in: .whitespaces))
        }
    }
    
    func search() {
        print("search text is from vm:\(searchText)")
        $searchText
            .sink { [weak self] searchText in
                guard let self = self else { return }
                filteredData = pokemonList.filter {
                    $0.name.lowercased().contains(searchText.lowercased().trimmingCharacters(in: .whitespaces))
                }
            }
            .store(in: &cancellable)
    }
}
