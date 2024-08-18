//
//  FavouriteViewController.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {

    var favouriteView: FavouriteView!
    var viewModel: FavouriteViewModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "My Favourites"
                        
        let didSaveNotification = NSManagedObjectContext.didSaveObjectsNotification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewEntrySaved),
                                               name: didSaveNotification,
                                               object: nil)
    }
    
    override func loadView() {
        viewModel = FavouriteViewModel()
        favouriteView = FavouriteView(viewModel: viewModel)
        self.view = favouriteView
    }
    
    @objc func didNewEntrySaved() {
        viewModel.getAllFavourites()
        favouriteView.tableView.reloadData()
    }
}
