// 
//  TappedRectangle.swift
//  GesturesAndRectDrawing
//
//  Created by Alina Zaitseva on 8/1/18.
//  Copyright © 2018 Alina Zaitseva. All rights reserved.
//

import UIKit

class TappedRectangle: UIView {
    
    private var points = [CGPoint]()
    private var state = 1
    private var numberOfTouches = 0
    private var activePoints = [Int]()
    private var pointsFlag = 0
    private let rectCatchArea : CGFloat = 50.0
    
    let keysWidth = [15, 25, 35, 45]
    let keysHeight = [15, 40, 25, 35]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        setGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func distanceToObject(_ a: [CGPoint], _ b: [CGPoint]) -> Bool {
        activePoints.removeAll()
        var result = false
        var distanceCounter = 0
        var index = 0
        var distance: CGFloat = 0.0
        for ap in a {
            index = 0
            for bp in b {
                index += 1
                let xDist = ap.x - bp.x
                let yDist = ap.y - bp.y
                distance = CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
                if distance <= rectCatchArea && distance >= 0 {
                    activePoints.append(index)
                    distanceCounter += 1
                    if distanceCounter == a.count {
                        result = true
                    }
                }
            }
        }
        return result
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touchArray = [CGPoint]()
        if points.count > 0 {
            touchArray.append((touches.first?.location(in: self))!)
            if distanceToObject(touchArray, points) {
                state = 1
            }
            else {
                state = 0
            }
        }
    }
    
    @objc private func doubleTapped() {
        self.removeFromSuperview()
    }
    
    @objc private func changeColor(pan: UILongPressGestureRecognizer ) {
        pan.minimumPressDuration = 0.3
        if pan.state == UIGestureRecognizerState.ended {
            self.backgroundColor = RandomColorPicker.getColor()
        }
    }
    
    @objc private func panRecog(pan : UIPanGestureRecognizer){
        if pan.state == .began || pan.state == .changed {
            let translation = pan.translation(in: pan.view?.superview)
            let posX = (self.center.x) + translation.x
            let posY = (self.center.y) + translation.y
            self.center = CGPoint(x: posX, y: posY)
            pan.setTranslation(CGPoint.zero, in: pan.view)
        }
    }
    
    @objc private func singleTap(_ tap :UITapGestureRecognizer){
        superview?.bringSubview(toFront: (tap.view)!)
        if pointsFlag == 0 { createPoints() }
        else { removePoints() }
    }
    
    @objc private func pinchScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer){
        var touchArray = [pinchRecognizer.location(ofTouch: 0, in: self)]
        if pinchRecognizer.numberOfTouches == 2 {
            touchArray.append(pinchRecognizer.location(ofTouch: 1, in: self))
        }
        if distanceToObject(touchArray, points) {
            if !activePoints.contains(5) {
                if pinchRecognizer.state == .began || pinchRecognizer.state == .changed {
                    var scaleX : CGFloat = 1.0
                    var scaleY : CGFloat = 1.0
                    if activePoints.count == 2 {
                        let positionCode = activePoints[0] * 10 + activePoints[1]
                        
                        if  keysWidth.contains(positionCode) {
                            scaleX = pinchRecognizer.scale
                        } else if keysHeight.contains(positionCode) {
                            scaleY = pinchRecognizer.scale
                        } else{
                            scaleX = pinchRecognizer.scale
                            scaleY = pinchRecognizer.scale
                        }
                    }
                    self.transform = (self.transform.scaledBy(x: scaleX, y: scaleY))
                    pinchRecognizer.scale = 1.0
                }
            }
        }
    }
    @objc private func rotation(gestureRecognizer : UIRotationGestureRecognizer){
        if state == 1, activePoints.contains(5) {
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                self.transform = self.transform.rotated(by: gestureRecognizer.rotation)
                gestureRecognizer.rotation = 0
            }
        }
    }
    
    private func removePoints(){
        pointsFlag = 0
        self.layer.sublayers?.removeAll()
    }
    
    private func createPoints() {
        pointsFlag = 1
        let radius :CGFloat = rectCatchArea
        let minX = self.bounds.minX
        let minY = self.bounds.minY
        let maxX = self.bounds.maxX
        let maxY = self.bounds.maxY
        
        let topLineX = minX < 0 ? self.frame.width / -2 : self.frame.width / 2
        
        points.append(CGPoint(x: minX, y: minY))
        points.append(CGPoint(x: maxX, y: minY))
        points.append(CGPoint(x: maxX, y: maxY))
        points.append(CGPoint(x: minX, y: maxY))
        points.append(CGPoint(x: topLineX, y: minY))
        
        var piModifier = 0.0
        for index in 0..<5 {
            if index == 4 {
                self.layer.addSublayer(CirclePainter.drawCircle(center: points[index], radius: radius, start: CGFloat(0), end: CGFloat(Double.pi)))
            } else {
                self.layer.addSublayer(CirclePainter.drawCircle(center: points[index], radius: radius, start: CGFloat(Double.pi * piModifier), end: CGFloat(Double.pi * (piModifier + 0.5))))
            }
            piModifier += 0.5
        }
    }
    
    private func setGestures(){
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(singleTap)))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panRecog)))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(changeColor)))
        self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchScale)))
        self.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotation)))
    }
    
}

