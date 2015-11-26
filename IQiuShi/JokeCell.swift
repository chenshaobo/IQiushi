//
//  JokeCell.swift
//  IQiuShi
//
//  Created by swift on 15/11/24.
//  Copyright © 2015年 chensb. All rights reserved.
//

import UIKit
import Haneke
import MBProgressHUD

class JokeCell: UITableViewCell {
    @IBOutlet weak var UserLogo: UIImageView!
    
    @IBOutlet weak var JokeContent: UILabel!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var JokeImage: UIImageView!
    
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    
    var vote = 0
    
    var  joke : Joke?{
        didSet {
            self.UserName.text = self.joke?.jokeOwner?.name
            self.JokeContent.text = self.joke?.jokeContent
            self.upButton.setTitle("👍(\(self.joke!.up))" ,forState:.Normal)
            self.downButton.setTitle("👎(\(self.joke!.down))" ,forState:.Normal)
            dispatch_async(dispatch_get_main_queue()){
            if let _ = self.joke?.jokeOwner?.logo {
                   let  url = self.getImage((self.joke?.jokeOwner?.id)!, type: 0)
                    self.UserLogo.hnk_setImageFromURL( NSURL(string:url)!)
                    self.UserLogo.layer.borderWidth = 1;  //设置的UIImageView的边框宽度
                    self.UserLogo.layer.borderColor = UIColor(white: 0.5, alpha: 0).CGColor 
                    self.UserLogo.layer.cornerRadius = CGRectGetHeight(self.UserLogo.bounds) / 2;   //这里才是实现圆形的地方
                    self.UserLogo.clipsToBounds = true;    //这里设置超出部分自动剪裁掉
                }}
            switch self.joke!.jokeType {
                case  .Text:
                        self.JokeImage.hidden  = true
                        self.JokeImage.image = nil
                        self.JokeImage.bounds = CGRectMake(0,0,5,5)
                case .Video:
                        self.JokeImage.hidden = true
                        self.JokeImage.image = nil
                        self.JokeImage.bounds = CGRectMake(0,0,5,5)
                case  .Image:
                    
                    self.JokeImage.hidden = false
                    let screenWidth = UIScreen.mainScreen().bounds.width
                    let width = CGFloat((self.joke?.imageWidth)!)
                    let height = CGFloat((self.joke?.imageHeight)!)
                    print("image :\(width) \(height)")
                    if screenWidth < width {
                        let newWidth = screenWidth
                        let ratio = width / height
                        let newHeight = screenWidth / CGFloat(ratio)
                        print("ratio:\(ratio) width \(newWidth) ,height \(newHeight)")
                        self.JokeImage.bounds = CGRectMake(0,0, newWidth, newHeight)
                    }else {
                        print("width \(width) ,height \(height)")
                        self.JokeImage.bounds = CGRectMake(0,0, width, height)
                    }
                    let url = self.getImage((self.joke?.id)!, type: 1)
                   	self.JokeImage.hnk_setImageFromURL(NSURL(string:url)!)
            }
        }
        
    }
    
    func getImage(id:Int,type:Int) -> String {
        let pre = id / 10000
        
        if type == 0 {
            return "\(USER_LOGO)\(pre)/\(id)/medium/\((self.joke?.jokeOwner?.logo)!)"
        }else{
            return "\(JOKE_IMG)\(pre)/\(id)/medium/\((self.joke?.jokeImage)!)"
        }
        
    }
    
    @IBAction func up(sender: UIButton) {
        if vote == 0  {
            vote  = 1
            self.upButton.setTitle("👍(\(self.joke!.up + vote))" ,forState:.Normal)
        }else if vote  == -1 {
            vote  = 1
            self.upButton.setTitle("👍(\(self.joke!.up + vote))" ,forState:.Normal)
            self.downButton.setTitle("👎(\(self.joke!.down ))" ,forState:.Normal)
        }else if vote == 1{
            alertShow("已经赞过啦")
        }
        
    }

    @IBAction func down(sender: UIButton) {
        if vote == 1 {
            vote = -1
            self.upButton.setTitle("👍(\(self.joke!.up ))" ,forState:.Normal)
            self.downButton.setTitle("👎(\(self.joke!.down + vote))" ,forState:.Normal)
        }else if vote == 0 {
            vote  = -1
            self.downButton.setTitle("👎(\(self.joke!.down + 	vote))" ,forState:.Normal)
        }else if vote == -1 {
            alertShow("已经踩过啦。。")
        }
    }
    
    func alertShow(message:String){
        let hud = MBProgressHUD.showHUDAddedTo(self.superview    , animated: true)
        hud.labelText = message
        hud.mode = MBProgressHUDMode.Text
        //背景渐变效果
        hud.dimBackground = true
        //延迟隐藏
        hud.hide(true, afterDelay: 0.5)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
