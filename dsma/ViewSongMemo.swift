//
//  ViewSongMemo.swift
//  dsma
//
//  Created by apple on 2024/04/07.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class ViewSongMemo: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate {
    
    @IBOutlet weak var adView: UIView!
    
    @IBOutlet weak var naviTitle: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var textBox: PlaceholderTextView!
    
    var buttonDone: UIBarButtonItem!
    var buttonCancel: UIBarButtonItem!
    
    var rparam_AddTarget: UniquePattern!
    
    var keyboardHeight: CGFloat = 0 // ViewControllerのプロパティとしてキーボードの高さを保持
    var mMag: CGFloat = 1 // Padの場合のサイズを変更？
    
    let realmUtil = RealmUtil()
    
    static func checkOut(_ target: UniquePattern) -> (ViewSongMemo) {
        let storyboard = UIStoryboard(name: "ViewSongMemo", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewSongMemo
        ret.rparam_AddTarget = target
        return ret
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDeviceIsPad()
        
        let musicId = rparam_AddTarget.MusicId
        // 上下に20ポイントのマージンを設定
        textBox.textContainerInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        textBox.placeHolder = NSLocalizedString("Please enter your memo.", comment: "ViewSongMemo")
        textBox.text = realmUtil.loadMemo(id: Int(musicId))
        
        buttonDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ViewMyList.doneButtonTouched(_:)))
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewMyList.cancelButtonTouched(_:)))
        
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
        
        naviTitle.title = NSLocalizedString("Memo", comment: "ViewSongMemo")
        navigationBar.delegate = self
        
        // キーボードの表示・非表示の通知を購読
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        adView.addSubview(Admob.getAdBannerView(self))
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = 0
    }
    
    // UIBarPositioningDelegate
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    fileprivate func checkDeviceIsPad() {
        let device = UIDevice.current.userInterfaceIdiom
        if device == UIUserInterfaceIdiom.pad {
            mMag = 1.5
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        realmUtil.saveOrUpdateMemo(id: Int(rparam_AddTarget.MusicId), text:textBox.text)
        showSaveSuccessMessage()
    }
    
    func showSaveSuccessMessage() {
        let labelHeight: CGFloat = 40
        let yOffset: CGFloat = self.view.frame.size.height - keyboardHeight - labelHeight - 20  // 20は余裕を持たせるための値
        let label = UILabel(frame: CGRect(x: 0, y: yOffset, width: self.view.frame.size.width, height: labelHeight))
        label.backgroundColor = UIColor.blue
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = NSLocalizedString("Memo saved.", comment: "ViewSongMemo")//"データが保存されました"
        self.view.addSubview(label)

        UIView.animate(withDuration: 2.0, delay: 1.0, options: [], animations: {
            label.alpha = 0.0
        }) { (completed) in
            label.removeFromSuperview()
        }
    }
    
    @objc func cancelButtonTouched(_ sender: UIBarButtonItem) {
        // キャンセルボタンが押されたときの処理
        self.dismiss(animated: true, completion: nil)
    }
}
