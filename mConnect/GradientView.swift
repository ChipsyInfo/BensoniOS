//
//  GradientView.swift
//  TownofMorrisville
//
//  Created by chipsy services on 08/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//
import UIKit
import QuartzCore
@IBDesignable open class GradientView: UIView {
    @IBInspectable open var topColor: UIColor? {
        didSet {
            configureView()
        }
    }
    @IBInspectable open var bottomColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    override open class var layerClass : AnyClass {
        return CAGradientLayer.self
    }
    
    /*public override init() {
        super.init()
        // calls initWithFrame
    }
    */
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        configureView()
    }
    
    func configureView() {
        let layer = self.layer as! CAGradientLayer
        //let locations = [ 0.0, 1.0 ]
        //layer.locations = locations
        let color1 =  UIColor.clear as UIColor
        let color2 =  UIColor.darkGray as UIColor
        let colors: Array <AnyObject> = [ color1.cgColor, color2.cgColor ]
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0.5, y: 0.0);
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.opacity = 0.8;
    }
}
@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
}
