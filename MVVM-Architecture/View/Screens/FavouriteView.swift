//
//  FavouriteView.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//

import UIKit
import Combine

class FavouriteView: UIView {
    
    private(set) lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavouriteViewCell.self, forCellReuseIdentifier: FavouriteViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var viewModel: FavouriteViewModel!
    var cancellable = Set<AnyCancellable>()
    
    init(frame: CGRect = .zero, viewModel: FavouriteViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(tableView)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FavouriteView {
    func observeDetailData() {
        viewModel
            .$detailData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                tableView.reloadData()
            }
            .store(in: &cancellable)
    }
}

extension FavouriteView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.detailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavouriteViewCell.identifier,
            for: indexPath
        ) as! FavouriteViewCell
        
        guard let viewModel = viewModel else { return cell }
        let data = viewModel.detailData[indexPath.row]
        
        if let url = data.sprites.frontDefault, (url != "") {
            cell.cellImageView.getImage(from: URL(string: url)!)
        }
        cell.nameLabel.text = data.name
        
        return cell
    }
}

extension FavouriteView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let viewModel = viewModel else { return }
            let data = viewModel.detailData[indexPath.row]
            viewModel.deleteFavourite(data: data)
        }
    }
}
