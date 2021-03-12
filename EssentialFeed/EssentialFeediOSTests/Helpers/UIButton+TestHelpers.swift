//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by John Roque Jorillo on 3/13/21.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
