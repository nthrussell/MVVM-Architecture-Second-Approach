//
//  HomeViewTest.swift
//  MVVM-Architecture
//
//  Created by russel on 15/8/24.
//

import XCTest
import Combine
@testable import MVVM_Architecture

class HomeViewTest: XCTestCase {
    
    var sut: HomeView!
    var viewModel: HomeViewModel!
    var mockStorageService: MockDetailStorageService!
    var cancellable = Set<AnyCancellable>()

    override func setUpWithError() throws {
        
        let homeApiServiceStub = HomeApiServiceStub(returning: .success(try DecodedPokemonList.SuccessModel()))
        viewModel = HomeViewModel(homeApiService: homeApiServiceStub)
        sut = HomeView(with: viewModel)
        
        let pokemonList = [
            PokemonList(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
            PokemonList(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2/"),
            PokemonList(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon/3/"),
            PokemonList(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/"),
            PokemonList(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/5/")
        ]
        
        viewModel.pokemonList = pokemonList
    }
    
    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        super .tearDown()
    }
    
    func test_view_components() {
        XCTAssertNotNil(sut.searchBar)
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.activityindicatorView)
    }
    
    func test_tableView_whenModelHasFiveList_shouldBeFiveRow() {
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 5)
    }
    
    func test_tableView_whenModelHasData_shoulHaveACell() {
        let indexPath = IndexPath(row: 4, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }
    
    func test_tableView_reloading() {
        let newData = PokemonList(name: "charizard", url: "https://pokeapi.co/api/v2/pokemon/10/")
        
        let expectation = XCTestExpectation(description: "tableView reload successfully")
        
        sut.viewModel
            .reloadtableView
            .sink { status in
                XCTAssertTrue(status)
                expectation.fulfill()
            }
            .store(in: &cancellable)
                
        wait(for: [expectation], timeout: 1)
        
        viewModel.filteredData.append(newData)
    }
}
