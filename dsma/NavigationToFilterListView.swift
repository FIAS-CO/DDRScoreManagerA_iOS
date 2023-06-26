//
//  NavigationToFilterListView.swift
//  dsm
//
//  Created by LinaNfinE on 6/30/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class NavigationToFilterListView: UINavigationController, UINavigationControllerDelegate {
    
    var rparam_ParentView: ScoreListView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? FilterListView {
            vc.rparam_ParentView = rparam_ParentView
        }
    }
    
}
