//
//  NCSplitViewController.swift
//  Nextcloud
//
//  Created by Marino Faggiana on 30/01/2020.
//  Copyright © 2020 Marino Faggiana. All rights reserved.
//
//  Author Marino Faggiana <marino.faggiana@nextcloud.com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

class NCSplitViewController: UISplitViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            self.maximumPrimaryColumnWidth = UIScreen.main.bounds.width
        } else {
            self.maximumPrimaryColumnWidth = UIScreen.main.bounds.height
        }
        self.preferredPrimaryColumnWidthFraction = 0.4
        
        let navigationController = viewControllers.first as? UINavigationController
        if let tabBarController = navigationController?.topViewController as? UITabBarController {
            appDelegate.createTabBarController(tabBarController)
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if CCUtility.getDarkModeDetect() {
                if traitCollection.userInterfaceStyle == .dark {
                    CCUtility.setDarkMode(true)
                } else {
                    CCUtility.setDarkMode(false)
                }
                // Use a timer for fix the twice call of traitCollectionDidChange for detect the Dark mode
                if !(timer?.isValid ?? false) {
                    timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerHandlerChangeTheming(_:)), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    @objc func timerHandlerChangeTheming(_ timer: Timer) {
        NotificationCenter.default.postOnMainThread(name: k_notificationCenter_changeTheming)
    }
}

extension NCSplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        NotificationCenter.default.postOnMainThread(name: k_notificationCenter_splitViewChangeDisplayMode)
    }
}
