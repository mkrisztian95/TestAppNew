//
//  LaunchViewController.swift
//  serveture
//
//  Created by Adam Herczeg on 2017. 02. 06..
//  Copyright © 2017. Haneke Design. All rights reserved.
//

import UIKit
import ServetureFramework

class LaunchViewController: LaunchBaseViewController {

override func viewDidAppear(_ animated: Bool) {
 super.viewDidAppear(animated)
 self.checkIfLoggedIn()
}
}
