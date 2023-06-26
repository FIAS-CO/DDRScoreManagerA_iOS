//
//  TouchDownTableView.swift
//  dsm
//
//  Created by LinaNfinE on 7/26/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class TouchDownTableView: UITableView {
    
    /*override func touchesShouldBegin(touches: Set<NSObject>!, withEvent event: UIEvent!, inContentView view: UIView!) -> Bool {
        let pt = (touches.first as! UITouch).locationInView(self)
        if let indexPath = self.indexPathForRowAtPoint(pt) {
            self.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        }
        return true
    }*/
    /*
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        /*NSOperationQueue().addOperationWithBlock({ () -> Void in
            usleep(1000000)
            dispatch_async(dispatch_get_main_queue(),{
                self.deselectRowAtIndexPath(self.mSelectedCellPath, animated: true)
            })
        })*/
    }
    */
    /*override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        if let indexPathes = self.indexPathsForSelectedRows() {
            if let indexPath = indexPathes.first as? NSIndexPath {
                self.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }*/
    /*
    override func touchesShouldCancelInContentView(view: UIView!) -> Bool {
        self.deselectRowAtIndexPath(mSelectedCellPath, animated: true)
        return true
    }
    */
}
