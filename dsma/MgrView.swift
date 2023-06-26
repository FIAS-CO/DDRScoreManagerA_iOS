//
//  MgrView.swift
//  dsm
//
//  Created by LinaNfinE on 9/14/15.
//  Copyright (c) 2015 LinaNfinE. All rights reserved.
//

import UIKit

class MgrView: UIView {
    
    var mPlayerStatus: PlayerStatus = PlayerStatus()
    
    var mMag: CGFloat = 1
    
    func setData(_ playerStatus: PlayerStatus){
        
        let device: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        if device == UIUserInterfaceIdiom.pad {
            mMag = 2.0
        }
        
        mPlayerStatus = playerStatus
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        /*let lineWidth: CGFloat = self.bounds.width / 100.0
        let center: CGPoint = CGPoint(x: rect.width/2, y: rect.height/2)
        let circle: UIBezierPath = UIBezierPath()
        circle.addArc(withCenter: center, radius: CGFloat(100)*CGFloat(rect.width/2)/CGFloat(210), startAngle: 0.0, endAngle: CGFloat(M_PI) * CGFloat(2), clockwise: false)
        UIColor.white.setStroke()
        circle.lineWidth = 1*mMag
        circle.stroke()
        circle.removeAllPoints()
        circle.addArc(withCenter: center, radius: CGFloat(97)*CGFloat(rect.width/2)/CGFloat(210), startAngle: 0.0, endAngle: CGFloat(M_PI) * CGFloat(2), clockwise: false)
        UIColor.lightGray.setFill()
        circle.fill()
        let g = UIGraphicsGetCurrentContext()
        g?.saveGState()
        circle.addClip()
        circle.removeAllPoints()
        circle.addArc(withCenter: center, radius: CGFloat(94)*CGFloat(rect.width/2)/CGFloat(210), startAngle: 0.0, endAngle: CGFloat(M_PI) * CGFloat(2), clockwise: false)
        UIColor.darkGray.setFill()
        circle.fill()
        circle.removeAllPoints()
        circle.addArc(withCenter: CGPoint(x: center.x, y: center.y-CGFloat(100)*CGFloat(rect.width/2)/CGFloat(210)), radius: CGFloat(130)*CGFloat(rect.width/2)/CGFloat(210), startAngle: 0.0, endAngle: CGFloat(M_PI) * CGFloat(2), clockwise: false)
        UIColor.white.setFill()
        circle.fill(with: CGBlendMode.screen, alpha: 0.5)
        circle.removeAllPoints()
        g?.restoreGState()
        let spPath: UIBezierPath = createPolygon([CGFloat(mPlayerStatus.SingleMgrStream)*CGFloat(rect.width/2)/CGFloat(210), CGFloat(mPlayerStatus.SingleMgrVoltage)*CGFloat(rect.width/2)/CGFloat(210), CGFloat(mPlayerStatus.SingleMgrAir)*CGFloat(rect.width/2)/CGFloat(210), CGFloat(mPlayerStatus.SingleMgrFreeze)*CGFloat(rect.width/2)/CGFloat(210), CGFloat(mPlayerStatus.SingleMgrChaos)*CGFloat(rect.width/2)/CGFloat(210)], center: center)
        let dpPath: UIBezierPath = createPolygon([CGFloat(mPlayerStatus.DoubleMgrStream)*CGFloat(rect.width/2)/CGFloat(210), CGFloat(mPlayerStatus.DoubleMgrVoltage)*CGFloat(rect.width/2)/CGFloat(210), CGFloat(mPlayerStatus.DoubleMgrAir)*CGFloat(rect.width/2)/CGFloat(210), CGFloat(mPlayerStatus.DoubleMgrFreeze)*CGFloat(rect.width/2)/CGFloat(210), CGFloat(mPlayerStatus.DoubleMgrChaos)*CGFloat(rect.width/2)/CGFloat(210)], center: center)
        let spFillColor: UIColor = UIColor(red: 0.0, green: 0.6, blue: 0.8, alpha: 0.4)
        spFillColor.setFill()
        spPath.fill()
        let dpFillColor: UIColor = UIColor(red: 0.8, green: 0.0, blue: 0.6, alpha: 0.4)
        dpFillColor.setFill()
        dpPath.fill()
        let spStrokeColor: UIColor = UIColor(red: 0.0, green: 0.8, blue: 1.0, alpha: 1.0)
        spStrokeColor.setStroke()
        spPath.lineWidth = lineWidth
        spPath.stroke()
        let dpStrokeColor: UIColor = UIColor(red: 1.0, green: 0.0, blue: 0.8, alpha: 1.0)
        dpStrokeColor.setStroke()
        dpPath.lineWidth = lineWidth
        dpPath.stroke()
        drawTexts([
            "Stream": mPlayerStatus.SingleMgrStream,
            "Voltage": mPlayerStatus.SingleMgrVoltage,
            "Air": mPlayerStatus.SingleMgrAir,
            "Freeze": mPlayerStatus.SingleMgrFreeze,
            "Chaos": mPlayerStatus.SingleMgrChaos,
        ],dpValues: [
            "Stream": mPlayerStatus.DoubleMgrStream,
            "Voltage": mPlayerStatus.DoubleMgrVoltage,
            "Air": mPlayerStatus.DoubleMgrAir,
            "Freeze": mPlayerStatus.DoubleMgrFreeze,
            "Chaos": mPlayerStatus.DoubleMgrChaos,
        ])*/
    }
    
    func drawTexts(_ spValues: [String : Int32], dpValues: [String : Int32]){
        /*var texts: [String] = ["Stream", "Voltage", "Air", "Freeze", "Chaos"]
        for index: Int in 0 ..< texts.count {
            let rad: CGFloat = CGFloat(M_PI) * CGFloat(-2.0) / CGFloat(texts.count) * CGFloat(index) - CGFloat(M_PI) / CGFloat(2.0)
            let drawPoint: CGPoint = CGPoint(x: center.x + CGFloat(165)*CGFloat(self.bounds.width/2)/CGFloat(210) * cos(rad), y: center.y + CGFloat(165)*CGFloat(self.bounds.height/2)/CGFloat(210) * sin(rad))
            let g: CGContext? = UIGraphicsGetCurrentContext()
            g?.setShouldSmoothFonts(true)
            let fontLarge: UIFont = UIFont(name: "Helvetica-Bold", size: 17*(self.bounds.width/320.0))!
            let paragraphStyle: NSParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSParagraphStyle
            var textFontAttributes: [String : AnyObject] = [
                NSFontAttributeName: fontLarge,
                NSForegroundColorAttributeName: UIColor.white,
                NSStrokeColorAttributeName: UIColor.darkGray,
                NSStrokeWidthAttributeName: -3 as AnyObject,
                NSParagraphStyleAttributeName: paragraphStyle,
            ]
            let textSize: CGSize = texts[index].size(attributes: textFontAttributes)
            let path: UIBezierPath = UIBezierPath()
            path.move(to: CGPoint(x: drawPoint.x-CGFloat(50)*CGFloat(self.bounds.width/2)/CGFloat(210), y: drawPoint.y-textSize.height))
            path.addLine(to: CGPoint(x: drawPoint.x+CGFloat(50)*CGFloat(self.bounds.width/2)/CGFloat(210), y: drawPoint.y-textSize.height))
            UIColor.lightGray.setStroke()
            path.lineWidth = 1.5*mMag
            path.stroke()
            texts[index].draw(in: CGRect(x: drawPoint.x-textSize.width/2, y: drawPoint.y-textSize.height*2, width: textSize.width, height: textSize.height), withAttributes: textFontAttributes)
            let fontSmall: UIFont = fontLarge.withSize(12*(self.bounds.width/320.0))
            textFontAttributes = [
                NSFontAttributeName: fontSmall,
                NSForegroundColorAttributeName: UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0),
                NSStrokeColorAttributeName: UIColor(red: 0.0, green: 0.2, blue: 0.4, alpha: 1.0),
                NSStrokeWidthAttributeName: -3 as AnyObject,
                NSParagraphStyleAttributeName: paragraphStyle,
            ]
            let spTextSize: CGSize = spValues[texts[index]]!.description.size(attributes: textFontAttributes)
            spValues[texts[index]]?.description.draw(in: CGRect(x: drawPoint.x-spTextSize.width/2, y: drawPoint.y-textSize.height, width: spTextSize.width, height: spTextSize.height), withAttributes: textFontAttributes)
            textFontAttributes = [
                NSFontAttributeName: fontSmall,
                NSForegroundColorAttributeName: UIColor(red: 1.0, green: 0.6, blue: 0.8, alpha: 1.0),
                NSStrokeColorAttributeName: UIColor(red: 0.4, green: 0.0, blue: 0.2, alpha: 1.0),
                NSStrokeWidthAttributeName: -3 as AnyObject,
                NSParagraphStyleAttributeName: paragraphStyle,
            ]
            let dpTextSize: CGSize = dpValues[texts[index]]!.description.size(attributes: textFontAttributes)
            dpValues[texts[index]]?.description.draw(in: CGRect(x: drawPoint.x-dpTextSize.width/2, y: drawPoint.y-textSize.height+dpTextSize.height*0.8, width: dpTextSize.width, height: dpTextSize.height), withAttributes: textFontAttributes)
        }*/
    }
    
    func createPolygon(_ radiusList: [CGFloat], center: CGPoint) -> UIBezierPath {
        let path: UIBezierPath = UIBezierPath()
        /*for index: Int in 0 ..< radiusList.count {
            let rad: CGFloat = CGFloat(M_PI) * CGFloat(-2.0) / CGFloat(radiusList.count) * CGFloat(index) - CGFloat(M_PI) / CGFloat(2.0)
            let drawPoint: CGPoint = CGPoint(x: center.x + radiusList[index] * cos(rad), y: center.y + radiusList[index] * sin(rad))
            if index == 0 {
                path.move(to: drawPoint)
            }
            else{
                path.addLine(to: drawPoint)
            }
        }*/
        path.close()
        return path
    }
}
