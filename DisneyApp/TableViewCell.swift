//
//  TableViewCell.swift
//  DisneyApp
//
//  Created by Sergey Goncharov on 22.12.2023.
//

import Foundation
import UIKit

final class TableViewCell: UITableViewCell {
    
    static let reuseId: String = "TableViewCell"
    
    private enum Constants {
        static let wrapColor: UIColor = .lightGray
        static let wrapOffsetV: CGFloat = 50
        static let wrapOffsetH: CGFloat = 0
        static let labelOffset: CGFloat = 8
        static let imageOffset: CGFloat = 8
    }
    
    private let name: UILabel = UILabel()
    private let image: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    private let films: UILabel = UILabel()
        
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(state: CellState) {
        self.name.text = state.name
        downloadImage(from: state.url)
        self.films.text = state.films
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        let screenSize: CGRect = UIScreen.main.bounds
        let wrap: UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        addSubview(wrap)
        wrap.backgroundColor = Constants.wrapColor
        wrap.pinVertical(to: self, Constants.wrapOffsetV)
        wrap.pinHorizontal(to: self, Constants.wrapOffsetH)
        wrap.addSubview(name)
        wrap.addSubview(image)
        wrap.addSubview(films)
        name.pinLeft(to: image.trailingAnchor, Constants.labelOffset)
        films.pinTop(to: image.bottomAnchor, Constants.labelOffset)
    }
    
    private func getData(from url: URL?, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        if url == nil {
            return
        }
        URLSession.shared.dataTask(with: url!, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL?) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image.image = UIImage(data: data)
            }
        }
    }
}

struct CellState {
    var name: String
    var url: URL?
    var films: String
}
