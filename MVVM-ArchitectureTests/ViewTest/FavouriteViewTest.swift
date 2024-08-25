//
//  FavouriteViewTest.swift
//  MVVM-Architecture
//
//  Created by russel on 15/8/24.
//

import XCTest
import Combine

@testable import MVVM_Architecture

class FavouriteViewTest: XCTestCase {
    var sut: FavouriteView!
    var viewModel: FavouriteViewModel!
    var mockStorageService: MockFavouriteStorageService!
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        mockStorageService = MockFavouriteStorageService()
        viewModel = FavouriteViewModel(favouriteStorageService: mockStorageService)
        sut = FavouriteView(viewModel: viewModel)

        let detailData = [
            PokemonDetailModel(
                height: 5,
                name: "test1",
                sprites: SpritesModel(frontDefault: "testSprite1"),
                weight: 3),
            PokemonDetailModel(
                height: 4,
                name: "test2",
                sprites: SpritesModel(frontDefault: "testSprite2"),
                weight: 6),
            PokemonDetailModel(
                height: 7,
                name: "test3",
                sprites: SpritesModel(frontDefault: "testSprite7"),
                weight: 3)
        ]
        
        viewModel.detailData.append(contentsOf: detailData)
        
        sut.tableView.reloadData()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        mockStorageService = nil
        super .tearDown()
    }
    
    func test_view_components() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_tableView_whenDetailDataHasThreeElement_shouldHaveThreeRow() {
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 3)
    }
    
    func test_tableView_whenDetailDataHaveAnElement_shoulHaveACell() {
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
        XCTAssertNotNil(cell)
    }
    
    func test_if_viewModel_detailData_sends_newData_successfully() {
        let detailData = [
            PokemonDetailModel(
                height: 5,
                name: "test1",
                sprites: SpritesModel(frontDefault: "https://pokeapi.co/api/v2/pokemon/1/"),
                weight: 3),
            PokemonDetailModel(
                height: 4,
                name: "test2",
                sprites: SpritesModel(frontDefault: "https://pokeapi.co/api/v2/pokemon/2/"),
                weight: 6)
        ]
        
        let expectation = XCTestExpectation(description: "Received New PokemonDetailModel data")
        
        sut.viewModel
            .$detailData
            .sink { status in
                XCTAssertTrue(status.count > 0)
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        wait(for: [expectation], timeout: 1)
        
        viewModel.detailData.append(contentsOf: detailData)
    }
}
