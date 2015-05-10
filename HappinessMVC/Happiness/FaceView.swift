//
//  FaceView.swift
//  Happiness
//
//  Created by Hsuching on 15/5/3.
//  Copyright (c) 2015年 Stanford. All rights reserved.
//

import UIKit

//定义一个协议
//表示这个协议只能被类实现
protocol FaceViewDataSource:class {
//    这个协议的作用是获取这个视图用来绘制的一些数据,因为视图不能拥有数据,这里需要一些用来获取数据的必需函数和属性
    func smilinessForFaceView(sender:FaceView) -> Double?
}


//实时可视化结果
@IBDesignable
class FaceView: UIView {

//    设置Property Observer：一旦改变就把这个view重绘
//    变为可设置属性
    @IBInspectable
    var lineWidth: CGFloat = 3 {
//        无论何时，有人改变它，它就会向自身调用setNeedsDisplay
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var color:UIColor = UIColor.blueColor(){
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var scale: CGFloat = 0.90 {
        didSet {
            setNeedsDisplay()
        }
    }
    
//    控制器与视图层次已经有了一个从 controller 到view 的引用,这是需要用 weak, 否则会多一个 view 到 controller 的引用,形成一个循环引用.将不会在内存中保存这个控制器,这个控制器将被允许在内存中释放.控制器将会设置它自身为这个dataSource
    weak var dataSource:FaceViewDataSource?
    
    /**
    *
    */
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    /**
    drawEye
    
    :param: whichEye <#whichEye description#>
    
    :returns: <#return value description#>
    */
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath
    {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(
            arcCenter: eyeCenter,
            radius: eyeRadius,
            startAngle: 0,
            endAngle: CGFloat(2*M_PI),
            clockwise: true
        )
        path.lineWidth = lineWidth
        return path
    }
    
    func scale(gesture:UIPinchGestureRecognizer){
        if gesture.state == .Changed{
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath
    {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    
//    把两个property变成computed properties
    var faceCenter: CGPoint{
//        把center从superview的坐标系转换到现在的坐标系。
        return convertPoint(center, fromView: superview)
    }
    var faceRadius: CGFloat{
        return min(bounds.size.width,bounds.size.height)/2 * scale
    }
    
    
//创建一个UIBezierPath
    override func drawRect(rect: CGRect) {
         let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth=lineWidth
        color.set()
        facePath.stroke()
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
//        使用 dataSource 获取 smiliness
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }


}
