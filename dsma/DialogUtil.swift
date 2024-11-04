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

class DialogUtils {
    
    static func showDataFetchOptions(from viewController: UIViewController,
                              processPool: WKProcessPool,
                              rivalId: String? = nil,
                              rivalName: String? = nil) {
        let alert = UIAlertController(
            title: "データ取得範囲の選択",
            message: "取得するデータの範囲を選択してください",
            preferredStyle: .alert  // actionSheetの代わりにalertを使用
        )
        
        // すべて取得
        alert.addAction(UIAlertAction(
            title: "すべて取得 (SP + DP)",
            style: .default
        ) {_ in
            viewController.present(ViewFromGateList2.checkOut(nil, playStyle: .all, rivalId: nil, rivalName: nil, processPool: processPool), animated: true, completion: nil)
        })
        
        // SPのみ取得
        alert.addAction(UIAlertAction(
            title: "SPのみ取得",
            style: .default
        ) { _ in
            viewController.present(ViewFromGateList2.checkOut(nil, playStyle: .sp, rivalId: nil, rivalName: nil, processPool: processPool), animated: true, completion: nil)
        })
        
        // DPのみ取得
        alert.addAction(UIAlertAction(
            title: "DPのみ取得",
            style: .default
        ) {_ in
            viewController.present(ViewFromGateList2.checkOut(nil, playStyle: .dp, rivalId: nil, rivalName: nil, processPool: processPool), animated: true, completion: nil)
        })
        
        // キャンセル
        alert.addAction(UIAlertAction(
            title: "キャンセル",
            style: .cancel
        ))
        
        viewController.present(alert, animated: true)
    }
    
}
