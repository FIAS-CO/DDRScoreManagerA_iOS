//
//  NavigationToSortListView.swift
//  dsm
//
//  Created by LinaNfinE on 6/30/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class NavigationToSortListView: UINavigationController, UINavigationControllerDelegate {
    
    var rparam_ParentView: ScoreListView!
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        let vc = viewController as! SortListView
        vc.rparam_ParentView = rparam_ParentView
    }
    
}
