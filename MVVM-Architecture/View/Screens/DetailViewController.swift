//
//  DetailViewController.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    var url: String
    var detailView = DetailView()
    var viewModel: DetailViewModel!
    
    var cancellable = Set<AnyCancellable>()
        
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Loader.show()
        viewModel = DetailViewModel(url: url)
        detailView.viewModel = viewModel
        
        observeData()
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Loader.hide()
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.visibleViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    func observeData() {
        viewModel
            .$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                if let data = result {
                    detailView.updateUI(data: data)
                    let value = viewModel.checkIfFavourite(data: data)
                    detailView.favouriteButton.isSelected = value
                }
            }
            .store(in: &cancellable)
    }
}
