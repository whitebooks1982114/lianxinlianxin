//
//  pageDetailViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/8.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit
import Kingfisher

class pageDetailViewController: UIViewController, UIScrollViewDelegate {
   
    var page = 0
    
    var selectedActivity: String?
    
    var perface: String?
    //最后一幅画得Index
    var lastOne = 0
    //判断加载图画方向
    var direction = true
   
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myScroll: UIScrollView!
    @IBOutlet var myView: UIView!
   
    //点击加载图片
    @IBAction func myTap(_ sender: UITapGestureRecognizer) {
        //获取触点位置
        let point = sender.location(in: self.myView)
         //点右边加载下一副图片
        if point.x > self.myView.frame.width / 2 {
            UIView.transition(with: self.myView, duration: 2.0, options: [.transitionFlipFromLeft , .allowAnimatedContent], animations:{
                if self.direction == false {
                    self.page += 2
                }
                self.myQuery()
                self.page += 1
                self.direction = true
                
                
                if self.page > self.lastOne{
                    self.page = self.lastOne
                }
                
                
            }, completion: nil)
            
        // 点左边加载上一幅图片
        }else {
            
            UIView.transition(with: self.myView, duration: 2.0, options: [.transitionFlipFromRight , .allowAnimatedContent], animations:{
                if self.direction == true {
                    self.page -= 2
                }
                
                self.myQuery()
                self.page -= 1
                self.direction = false
                
                if self.page < 0 {
                    self.page = 0
                }
                
            }, completion: nil)
            
        }
        
          }
    
    
    @IBAction func myPinch(_ sender: UIPinchGestureRecognizer) {
        
        if sender.state == .ended {
            sender.scale = 1.0
        }
        
        let _width = myScroll.bounds.width
        let _height = myScroll.bounds.height
      
        myScroll.bounds.size = CGSize(width: _width * sender.scale, height: _height * sender.scale)
    
    }
    
    
    func myQuery() {
        
        let query1 = BmobQuery(className: "works")
        let query2 = BmobQuery(className: "works")
        let main = BmobQuery(className: "works")
        query1?.whereKey("activity", equalTo: selectedActivity)
        query2?.whereKey("index", equalTo: page)
        main?.add(query1)
        main?.add(query2)
        main?.andOperation()
        var myUrl:URL?
        main?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }
            if array != nil {
                for obj in array! {
                    let myObject = obj as! BmobObject
                    let myFile = myObject.object(forKey: "works") as! BmobFile
                    myUrl = URL(string: myFile.url)
                }
            }
            DispatchQueue.main.async {
               self.myImageView.kf.setImage(with: ImageResource.init(downloadURL: myUrl!), placeholder: UIImage(named:"默认图片"), options: nil, progressBlock: nil, completionHandler: nil)
                
            }

        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       myScroll.minimumZoomScale = 0.5
       myScroll.maximumZoomScale = 2.0
        myScroll.bounces = true
       myScroll.contentSize = CGSize(width: self.myView.frame.width * 1.5, height: self.myView.frame.height * 1.5)
        myScroll.delegate = self
       //重要否则无法缩放图片
        myScroll.isUserInteractionEnabled = true
    }
    //此方法重要，否则无法缩放图片
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return myImageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       myImageView.image = UIImage(named: perface!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        page = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
