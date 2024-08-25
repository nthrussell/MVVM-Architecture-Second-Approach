//
//  FavouriteViewController.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//

import UIKit
import CoreData

class FavouriteViewController: BindViewController<FavouriteView, FavouriteViewModel> {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.title = "My Favourites"
        
        viewModel.getAllFavourites()
                        
        let didSaveNotification = NSManagedObjectContext.didSaveObjectsNotification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didNewEntrySaved),
                                               name: didSaveNotification,
                                               object: nil)
    }
    
    @objc func didNewEntrySaved() {
        viewModel.getAllFavourites()
        rootView.tableView.reloadData()
    }
}
