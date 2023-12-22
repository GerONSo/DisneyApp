//
//  CharactersViewController.swift
//  DisneyApp
//
//  Created by Sergey Goncharov on 22.12.2023.
//

import Foundation
import UIKit
import os

final class CharactersViewController: UIViewController, UITableViewDataSource {

    private let table: UITableView = UITableView(frame: .zero)
    private let screenTitle = UILabel()
    private var data: [CellState] = []
    private let api = Api()
    private var lastResult: LocalData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getLocalData(url: nil)
        configureTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TableViewCell.reuseId,
            for: indexPath
        )
        guard let tableViewCell = cell as? TableViewCell else { return cell }
        tableViewCell.configure(state: data[indexPath.row])
        if (indexPath.row == data.count - 1) {
            getLocalData(url: lastResult?.info.nextPage)
        }
        return tableViewCell
    }
    
    private func configureTableView() {
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseId)
        view.addSubview(table)
        table.dataSource = self
        table.separatorStyle = .none
        table.pinHeight(to: view)
        table.pinHorizontal(to: view, 30)
    }
    
    private func getLocalData(url: String?) {
        Task {
            let result = if (url == nil) {
                await api.get()
            } else {
                await api.get(url: url!)
            }
            lastResult = result!
            DispatchQueue.main.async {
                self.data.append(contentsOf: result?.data.map { char in
                        CellState(
                            name: char.name,
                            url: URL(string: char.imageUrl ?? ""),
                            films: char.films.joined(separator: ",")
                        )
                    } ?? []
                )
                self.table.reloadData()
            }
        }
    }

}

