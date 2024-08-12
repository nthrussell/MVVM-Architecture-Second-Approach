//
//  BindViewController.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//

import UIKit

class BindViewController<View: UIView, ViewModel>: UIViewController {
    let rootView: View
    let viewModel: ViewModel
    
    init(with view: View, and viewModel: ViewModel) {
        self.rootView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadView() {
        view = rootView
    }
}
