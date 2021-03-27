//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by John Roque Jorillo on 3/13/21.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
