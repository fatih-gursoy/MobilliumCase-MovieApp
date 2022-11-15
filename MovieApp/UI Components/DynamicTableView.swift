//
//  DynamicTableView.swift
//  MovieApp
//
//  Created by Fatih Gursoy on 15.11.2022.
//

import UIKit

final class DynamicTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return self.contentSize
    }
}
