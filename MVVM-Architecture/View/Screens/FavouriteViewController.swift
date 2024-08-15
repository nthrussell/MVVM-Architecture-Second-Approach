//
//  FavouriteViewController.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//

import UIKit
import CoreData
import Combine

class FavouriteViewController: UIViewController {

    var favouriteView = FavouriteView()
    var viewModel = FavouriteViewModel()
    
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "My Favourites"
        
        observeDetailData()
                
        let didSaveNotification = NSManagedObjectContext.didSaveObjectsNotification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewEntrySaved),
                                               name: didSaveNotification,
                                               object: nil)
    }
    
    override func loadView() {
        favouriteView.viewModel = viewModel
        self.view = favouriteView
    }
    
    func observeDetailData() {
        viewModel
            .$detailData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                favouriteView.tableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    @objc func didNewEntrySaved() {
        viewModel.getAllFavourites()
        favouriteView.tableView.reloadData()
    }
}
