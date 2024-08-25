//
//  FavouriteView.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//

import UIKit
import Combine

class FavouriteView: BindView<FavouriteViewModel> {
    
    private(set) lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavouriteViewCell.self, forCellReuseIdentifier: FavouriteViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var cancellable = Set<AnyCancellable>()
    
    override func setupViews() {
        backgroundColor = .white
        
        addSubview(tableView)
        observeDetailData()
    }
    
    override func setupLayouts() {
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
            .sink { [weak self] _ in
                guard let self else { return }
                tableView.reloadData()
            }
            .store(in: &cancellable)
    }
}

extension FavouriteView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.detailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FavouriteViewCell.identifier,
            for: indexPath
        ) as! FavouriteViewCell
        
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
            let data = viewModel.detailData[indexPath.row]
            viewModel.deleteFavourite(data: data)
        }
    }
}
