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
    var detailView: DetailView!
    var viewModel: DetailViewModel!
    
        
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
    }
    
    override func loadView() {
        viewModel = DetailViewModel(url: url)
        detailView = DetailView(viewModel: viewModel)
        self.view = detailView
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Loader.hide()
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.visibleViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
}
