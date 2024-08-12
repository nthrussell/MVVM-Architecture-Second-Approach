//
//  HomeViewController.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    let viewModel = HomeViewModel()
    var homeView: HomeView!
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "Pokedex"
        
        bindPokemonList()
        bindFilteredData()
    }
    
    func bindPokemonList() {
        viewModel
            .$pokemonList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                if result.count > 0 {
                    self.homeView.tableView.reloadData()
                }
            }
            .store(in: &cancellable)
    }
    
    func bindFilteredData() {
        viewModel
            .$filteredData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                if result.count > 0 {
                    self.homeView.tableView.reloadData()
                }
            }
            .store(in: &cancellable)

    }
    
    override func loadView() {
        homeView = HomeView(viewModel: viewModel)
        self.view = homeView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigate()
    }
    
    func navigate() {
        homeView.onTap = { [weak self] url in
            guard let self = self else { return }
            let vc = DetailViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
