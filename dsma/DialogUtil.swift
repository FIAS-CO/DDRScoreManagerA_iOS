//
//  DialogUtil.swift
//  dsma
//
//  Created by apple on 2024/11/04.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DialogUtil {
    
    static func showDataFetchOptions(from viewController: UIViewController,
                                     processPool: WKProcessPool,
                                     rivalId: String? = nil,
                                     rivalName: String? = nil,
                                     refreshAfter: Bool = false) {
        let alertMessage = rivalId == nil ?
        NSLocalizedString("Load all scores from GATE with no detail data.", comment: "DialogUtil")
        :NSLocalizedString("Load active rival's all scores from GATE with no detail data.", comment: "DialogUtil")
        
        let parentView =
            refreshAfter && viewController is ViewScoreList ? viewController as? ViewScoreList : nil
        
        let alert = UIAlertController(
            title: NSLocalizedString("from GATE (simple)", comment: "DialogUtil"),
            message: alertMessage,
            preferredStyle: .alert  // actionSheetの代わりにalertを使用
        )
        
        // すべて取得
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Load all data (SP + DP)", comment: "DialogUtil"),
            style: .default
        ) {_ in
            viewController.present(ViewFromGateList2.checkOut(parentView, playStyle: .all, rivalId: rivalId, rivalName: rivalName, processPool: processPool), animated: true, completion: nil)
        })
        
        // SPのみ取得
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Load SP only", comment: "DialogUtil"),
            style: .default
        ) { _ in
            viewController.present(ViewFromGateList2.checkOut(parentView, playStyle: .sp, rivalId: rivalId, rivalName: rivalName, processPool: processPool), animated: true, completion: nil)
        })
        
        // DPのみ取得
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Load DP only", comment: "DialogUtil"),
            style: .default
        ) {_ in
            viewController.present(ViewFromGateList2.checkOut(parentView, playStyle: .dp, rivalId: rivalId, rivalName: rivalName, processPool: processPool), animated: true, completion: nil)
        })
        
        // キャンセル
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("Cancel", comment: "DialogUtil"),
            style: .cancel
        ))
        
        viewController.present(alert, animated: true)
    }
    
}
