//
//  DetailViewTest.swift
//  MVVM-Architecture
//
//  Created by russel on 15/8/24.
//

import XCTest
import Combine
@testable import MVVM_Architecture

class DetailViewTest: XCTestCase {
    var sut: DetailView!
    var viewModel: DetailViewModel!
    var mockStorageService: MockDetailStorageService!
    var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        
        mockStorageService = MockDetailStorageService()
        
        let json = """
                   {
                     "height": 6,
                     "name":"bulbasur",
                     "weight": 7,
                     "sprites" : {
                                   "front_default": "some image url"
                                 }
                   }
        """

        let data = try XCTUnwrap(json.data(using: .utf8))
        let pokemonDetailModel = try JSONDecoder().decode(PokemonDetailModel.self, from: data)

        let detailApiServiceStub = DetailApiServiceStub(returning: .success(pokemonDetailModel))
        
        viewModel = DetailViewModel(url: "", detailApiService: detailApiServiceStub,  detailStorageService: mockStorageService)
        
        sut = DetailView(viewModel: viewModel)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        mockStorageService = nil
        super .tearDown()
    }
    
    func test_view_components() {
        XCTAssertNotNil(sut.containerView)
        XCTAssertNotNil(sut.favouriteButton)
        XCTAssertNotNil(sut.imageView)
        XCTAssertNotNil(sut.nameLabel)
        XCTAssertNotNil(sut.weightlabel)
        XCTAssertNotNil(sut.heightlabel)
    }
    
    func test_updateUI() {
        let detailModelData = PokemonDetailModel(
            height: 10,
            name: "rattata",
            sprites: SpritesModel(frontDefault: "rattata_image"),
            weight: 8)
        
        sut.updateUI(data: detailModelData)
        
        XCTAssertEqual(sut.nameLabel.text, "rattata")
        XCTAssertEqual(sut.heightlabel.text, "height: \(detailModelData.height) cm")
        XCTAssertEqual(sut.weightlabel.text, "weight: \(detailModelData.weight) gm")
        XCTAssertEqual(sut.favouriteButton.isHidden, false)
    }
    
    func test_onTap_succeed_when_touch_up_inside() {
        let detailModelData = PokemonDetailModel(
            height: 10,
            name: "rattata",
            sprites: SpritesModel(frontDefault: "rattata_image"),
            weight: 8)
        
        viewModel.data = detailModelData
        
        sut.favouriteButton.isSelected = false
          
        sut.favouriteButton.sendActions(for: .touchUpInside)          
        XCTAssertEqual(sut.favouriteButton.isSelected, true)
      }
    
    func test_ifUIUpdate_successfully_when_thereIsANewData_in_viewModel_data() {
        let detailModelData = PokemonDetailModel(
            height: 19,
            name: "arcanine",
            sprites: SpritesModel(frontDefault: "arcanine_image"),
            weight: 1550)
        
        let expectation = XCTestExpectation(description: "UI updated successfully")
        
        sut.viewModel
            .$data
            .sink { [weak self] payload in
                guard let self else { return }
                if let data = payload {
                    sut.updateUI(data: data)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        wait(for: [expectation], timeout: 1)
        
        viewModel.data = detailModelData
        
        XCTAssertEqual(sut.nameLabel.text, "arcanine")
        XCTAssertEqual(sut.heightlabel.text, "height: \(detailModelData.height) cm")
        XCTAssertEqual(sut.weightlabel.text, "weight: \(detailModelData.weight) gm")
        XCTAssertEqual(sut.favouriteButton.isHidden, false)
    }
}
