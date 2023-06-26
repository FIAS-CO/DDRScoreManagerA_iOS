//
//  ViewCopyFormatList.swift
//  dsma
//
//  Created by LinaNfinE on 5/24/16.
//  Copyright © 2016 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewCopyFormatList: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate, UIScrollViewDelegate, UITextViewDelegate {
    
    static func checkOut(_ parentView: ViewScoreList, targetPattern: UniquePattern?, targetMusicData: MusicData?, targetScoreData: ScoreData?) -> (ViewCopyFormatList) {
        let storyboard = UIStoryboard(name: "ViewCopyFormatList", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewCopyFormatList
        ret.rparam_ParentView = parentView
        ret.rparam_targetPattern = targetPattern
        ret.rparam_targetMusicData = targetMusicData
        ret.rparam_targetScoreData = targetScoreData
        if ret.rparam_targetPattern == nil {
            ret.rparam_targetPattern = UniquePattern()
            ret.rparam_targetPattern.Pattern = .ESP
        }
        if ret.rparam_targetMusicData == nil {
            ret.rparam_targetMusicData = MusicData()
            ret.rparam_targetMusicData.Difficulty_ESP = 8
            ret.rparam_targetMusicData.Name = "Music Name"
        }
        if ret.rparam_targetScoreData == nil {
            ret.rparam_targetScoreData = ScoreData()
            ret.rparam_targetScoreData.ClearCount = 7
            ret.rparam_targetScoreData.PlayCount = 9
            ret.rparam_targetScoreData.MaxCombo = 98
            ret.rparam_targetScoreData.Rank = .Ap
            ret.rparam_targetScoreData.Score = 23450
        }
        return ret
    }
    
    var rparam_ParentView: ViewScoreList!
    var rparam_targetPattern: UniquePattern!
    var rparam_targetMusicData: MusicData!
    var rparam_targetScoreData: ScoreData!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textViewFormat0: UITextView!
    @IBOutlet weak var textViewPreview0: UITextView!
    @IBOutlet weak var textViewFormat1: UITextView!
    @IBOutlet weak var textViewPreview1: UITextView!
    @IBOutlet weak var textViewFormat2: UITextView!
    @IBOutlet weak var textViewPreview2: UITextView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView {
        case textViewFormat0:
            OperationQueue().addOperation({ () -> Void in
                usleep(100000)
                DispatchQueue.main.async(execute: {
                    self.textViewPreview0.text = StringUtil.textFromCopyFormat(textView.text, targetPattern: self.rparam_targetPattern, targetMusicData: self.rparam_targetMusicData, targetScoreData: self.rparam_targetScoreData)
                })
            })
            break;
        case textViewFormat1:
            OperationQueue().addOperation({ () -> Void in
                usleep(100000)
                DispatchQueue.main.async(execute: {
                    self.textViewPreview1.text = StringUtil.textFromCopyFormat(textView.text, targetPattern: self.rparam_targetPattern, targetMusicData: self.rparam_targetMusicData, targetScoreData: self.rparam_targetScoreData)
                })
            })
            break;
        case textViewFormat2:
            OperationQueue().addOperation({ () -> Void in
                usleep(100000)
                DispatchQueue.main.async(execute: {
                    self.textViewPreview2.text = StringUtil.textFromCopyFormat(textView.text, targetPattern: self.rparam_targetPattern, targetMusicData: self.rparam_targetMusicData, targetScoreData: self.rparam_targetScoreData)
                })
            })
            break;
        default: break;
        }
        return true
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buttonSave = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(ViewCopyFormatList.saveButtonTouched(_:)))
        let bb = [UIBarButtonItem](arrayLiteral: buttonSave)
        navigationBar.topItem?.rightBarButtonItems = bb
        buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(ViewCopyFormatList.cancelButtonTouched(_:)))
        let bl = [UIBarButtonItem](arrayLiteral: buttonCancel)
        navigationBar.topItem?.leftBarButtonItems = bl
        Admob.shAdView(adHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nvFrame: CGRect = navigationBar.frame;
        scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y, left: 0, bottom: 0, right: 0)
    }
    
    var mMag: CGFloat = 1
    
    @objc func applicationWillEnterForeground() {
        Admob.shAdView(adHeight)
    }
    
    var mFormats: [String]!
    
    @objc internal func saveButtonTouched(_ sender: UIButton) {
        mFormats[0] = textViewFormat0.text
        mFormats[1] = textViewFormat1.text
        mFormats[2] = textViewFormat2.text
        FileReader.saveCopyFormats(mFormats)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func cancelButtonTouched(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    var buttonSave: UIBarButtonItem!
    var buttonCancel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        adView.addSubview(Admob.getAdBannerView(self))
        
        let device = UIDevice.current.userInterfaceIdiom
        if device == UIUserInterfaceIdiom.pad {
            mMag = 1.5
        }
        
        textViewFormat0.delegate = self
        textViewFormat1.delegate = self
        textViewFormat2.delegate = self
        
        let nvFrame: CGRect = navigationBar.frame;
        scrollView.contentInset = UIEdgeInsets(top: nvFrame.origin.y, left: 0, bottom: 0, right: 0)
        navigationBar.delegate = self
        
        scrollView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        scrollView.delegate = self
        
        mFormats = FileReader.readCopyFormats()
        textViewFormat0.text = mFormats[0]
        textViewPreview0.text = StringUtil.textFromCopyFormat(mFormats[0], targetPattern: self.rparam_targetPattern, targetMusicData: self.rparam_targetMusicData, targetScoreData: self.rparam_targetScoreData)
        textViewFormat1.text = mFormats[1]
        textViewPreview1.text = StringUtil.textFromCopyFormat(mFormats[1], targetPattern: self.rparam_targetPattern, targetMusicData: self.rparam_targetMusicData, targetScoreData: self.rparam_targetScoreData)
        textViewFormat2.text = mFormats[2]
        textViewPreview2.text = StringUtil.textFromCopyFormat(mFormats[2], targetPattern: self.rparam_targetPattern, targetMusicData: self.rparam_targetMusicData, targetScoreData: self.rparam_targetScoreData)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
