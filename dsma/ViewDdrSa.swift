//
//  ViewDdrSa.swift
//  dsm
//
//  Created by LinaNfinE on 7/5/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewDdrSa: UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, GADBannerViewDelegate {
    
    static func checkOut() -> (ViewDdrSa) {
        let storyboard = UIStoryboard(name: "ViewDdrSa", bundle: nil)
        let ret = storyboard.instantiateInitialViewController() as! ViewDdrSa
        return ret
    }
    
    //let sSaUri = "http://skillattack.com/sa4_develop/";
    let sSaUri = "http://skillattack.com/sa4/";
    
    var sparam_SaUri: String!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adHeight: NSLayoutConstraint!
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var labelAuthenicateId: UILabel!
    @IBOutlet weak var buttonExport: UIButton!
    @IBOutlet weak var buttonAuthenticate: UIButton!
    @IBOutlet weak var buttonUnauthenticate: UIButton!
    @IBOutlet weak var buttonOpenUserPage: UIButton!
    
    @IBAction func buttonExportTouchUpInside(_ sender: AnyObject) {
        //sparam_SaUri = sSaUri
        //performSegueWithIdentifier("modalDdrSaExport",sender: nil)
        present(ViewDdrSaExport.checkOut(sSaUri), animated: true, completion: nil)
    }
    @IBAction func buttonAuthenicateTouchUpInside(_ sender: AnyObject) {
        //sparam_SaUri = sSaUri
        //performSegueWithIdentifier("modalDdrSaAuthenticate",sender: nil)
        present(ViewDdrSaAuthenticate.checkOut(sSaUri), animated: true, completion: nil)
    }
    @IBAction func buttonUnauthenicateTouchUpInside(_ sender: AnyObject) {
        FileReader.saveDdrSaAuthentication("", encryptedPassword: "")
        setState()
    }
    @IBAction func buttonOpenUserPageTouchUpInside(_ sender: AnyObject) {
        let str = sSaUri + "dancer_profile.php?ddrcode=" + mSaId
        UIApplication.shared.open(URL(string: str)!)
    }
    @IBAction func buttonOpenDdrSaWebSiteTouchUpInside(_ sender: AnyObject) {
        UIApplication.shared.open(URL(string: sSaUri)!)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    var mSaId: String!
    
    func setState() {
        if let saa = FileReader.readDdrSaAuthentication() {
            mSaId = saa[0]
            labelAuthenicateId.text = NSLocalizedString("Authentication ID: ", comment: "ViewDdrSa") + saa[0]
            buttonExport.isEnabled = true
            buttonAuthenticate.isEnabled = false
            buttonUnauthenticate.isEnabled = true
            buttonOpenUserPage.isEnabled = true
        }
        else {
            labelAuthenicateId.text = NSLocalizedString("Press \"Authenticate\" button \r\n to authenticate DDR SA.", comment: "ViewDdrSa")
            buttonExport.isEnabled = false
            buttonAuthenticate.isEnabled = true
            buttonUnauthenticate.isEnabled = false
            buttonOpenUserPage.isEnabled = false
        }
    }
    
    @objc internal func stopButtonTouched(_ sender: UIButton) {
        //presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setState()
        buttonStop = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(ViewDdrSa.stopButtonTouched(_:)))
        let bl = [UIBarButtonItem](arrayLiteral: buttonStop)
        navigationBar.topItem?.leftBarButtonItems = bl
        //Admob.shAdView(adHeight)
    }
    
    var buttonStop: UIBarButtonItem!
    
    @objc func applicationWillEnterForeground() {
        //Admob.shAdView(adHeight)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notifc: NotificationCenter = NotificationCenter.default
        notifc.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        self.title = "DDR SA"
        //adView.addSubview(Admob.getAdBannerView(self))

        bgView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        navigationBar.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
