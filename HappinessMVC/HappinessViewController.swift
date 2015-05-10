//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Hsuching on 15/5/3.
//  Copyright (c) 2015年 Stanford. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController,FaceViewDataSource {
    
    
    @IBOutlet weak var faceView: FaceView!{
//        property observer,在 iOS 运行, storyboard 加载连接 outlet 的时候设置这个变量
        didSet{
            faceView.dataSource = self
//            为 faceView 添加 Pinch 手势控制器
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
//            为faceView 添加 Pan 手势控制器,由于影响到 model,所以 target 设为 self
//            faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "changeHappiness:"))
        }
    }
    
    private struct Constants{
        static let HappinessGestureScale:CGFloat = 4
    }
    
//    controller负责将坐标的变换做解释,为Model解释View发生的变换,
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state{
        case .Ended:fallthrough
        case .Changed:
//            得到手势在 faceView 坐标系中的转换结果
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y/Constants.HappinessGestureScale)
            if happinessChange != 0{
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
            
        default:break
        }
        
    }
    
    var happiness: Int = 75 {   // 0 = very sad, 100 = ecstatic
        didSet{
            happiness = min(max(happiness,0),100)
            println("happiness = \(happiness)")
            updateUI()
        }
    }

    
//    controller负责为 view 解析 model
    func smilinessForFaceView(sender: FaceView) -> Double? {
        
        return Double(happiness-50)/50
    }
    
    private func updateUI(){
        faceView.setNeedsDisplay()
    }
}
