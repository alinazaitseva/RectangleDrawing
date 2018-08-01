//
//  ViewController.swift
//  GesturesAndRectDrawing
//
//  Created by Alina Zaitseva on 8/1/18.
//  Copyright © 2018 Alina Zaitseva. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var tapCount = 0
    private var tapfinishDraw = 0 {
        didSet {
            setNewRectangle()
        }
    }
    private var rectTopCornerPoint = CGPoint(x:0, y:0)
    private var rectBottomCornerPoint = CGPoint(x: 0, y: 0)
    private var layerLast = CALayer()
    private var viewLast: UIView?
    private var isViewPainting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc private func tapOccured(_ tap: UITapGestureRecognizer) {
        
        tapCount += 1
        if tapCount == 1 {
            rectTopCornerPoint = tap.location(in: self.view)
            layerLast = CirclePainter.drawCircle(center: rectTopCornerPoint, radius: CGFloat(15.0), start: CGFloat(0), end: CGFloat(Double.pi * 2))
            self.view.layer.addSublayer(layerLast)
        } else {
            rectBottomCornerPoint = tap.location(in: self.view)
            tapCount = 0
            tapfinishDraw += 1
            layerLast.removeFromSuperlayer()
        }
    }
    
    private func setNewRectangle(){
        
        let height = rectBottomCornerPoint.y - rectTopCornerPoint.y
        let width = rectBottomCornerPoint.x - rectTopCornerPoint.x
        let size = CGSize(width: width, height: height)
        let h = height < 0 ? height * (-1) : height
        let w = width < 0 ? width * (-1) : width
        
        if h < 100.0  || w < 100.0  {
            tapCount = 0
            return
        }
        
        let newRectangle = TappedRectangle(frame: CGRect(origin: rectTopCornerPoint, size: size))
        
        if isViewPainting {
            viewLast = newRectangle
        }
        view.addSubview(newRectangle)
    }
    
    @objc private  func panRecognizer(pan : UIPanGestureRecognizer){
        switch pan.state {
        case .began : rectTopCornerPoint = pan.location(ofTouch: 0, in: self.view)
        layerLast.removeFromSuperlayer()
        case .changed :
            rectBottomCornerPoint = pan.location(ofTouch: 0, in: self.view)
            isViewPainting = true
            if  viewLast != nil {
                viewLast?.removeFromSuperview()
            }
            setNewRectangle()
        case .ended :
            isViewPainting = false
            viewLast = nil
        default:
            return
        }
    }
    private func setGestures(){
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panRecognizer(pan:))))
        let gestTap = UITapGestureRecognizer(target: self, action: #selector(tapOccured(_ :)))
        self.view.addGestureRecognizer(gestTap)
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        let views = self.view.subviews
        let motionResult = views.map{$0.backgroundColor = RandomColorPicker.getColor()}
    }
    
}

