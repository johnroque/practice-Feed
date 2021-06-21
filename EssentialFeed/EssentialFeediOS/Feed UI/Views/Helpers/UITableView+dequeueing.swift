//
//  UITableView+dequeueing.swift
//  EssentialFeediOS
//
//  Created by John Roque Jorillo on 3/23/21.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
