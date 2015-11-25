//
//  JokeCell.swift
//  IQiuShi
//
//  Created by swift on 15/11/24.
//  Copyright © 2015年 chensb. All rights reserved.
//

import UIKit
import Haneke


class JokeCell: UITableViewCell {
    @IBOutlet weak var UserLogo: UIImageView!
    
    @IBOutlet weak var JokeContent: UILabel!
    @IBOutlet weak var UserName: UILabel!
    
    var  joke : Joke?{
        didSet {
            self.UserName.text = self.joke?.jokeOwner?.name
            self.JokeContent.text = self.joke?.jokeContent
            if let _ = self.joke?.jokeOwner?.logo {
                dispatch_async(dispatch_get_main_queue()){
                let userIDstr = (self.joke?.jokeOwner?.id)!
                let pre = userIDstr / 10000
                let url = "\(USER_LOGO)\(pre)/\(userIDstr)/medium/\((self.joke?.jokeOwner?.logo)!)"
                self.UserLogo.hnk_setImageFromURL( NSURL(string:url)!)
                    self.UserLogo.layer.borderWidth = 1;  //设置的UIImageView的边框宽度
                    self.UserLogo.layer.borderColor = UIColor(white: 0.5, alpha: 0).CGColor 
                    self.UserLogo.layer.cornerRadius = CGRectGetHeight(self.UserLogo.bounds) / 2;   //这里才是实现圆形的地方
                    self.UserLogo.clipsToBounds = true;    //这里设置超出部分自动剪裁掉
            }
            }
        }
    }

}
