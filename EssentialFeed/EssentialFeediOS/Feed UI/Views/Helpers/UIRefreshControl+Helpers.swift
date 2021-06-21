//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by John Roque Jorillo on 3/30/21.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
