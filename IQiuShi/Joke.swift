//
//  Joke.swift
//  IQiuShi
//
//  Created by swift on 15/11/24.
//  Copyright © 2015年 chensb. All rights reserved.
//

import Foundation
import SwiftyJSON

enum JokeType{
    case Text
    case Image
    case Video
}
class Joke{
    var jokeType :JokeType
    init(json:SwiftyJSON.JSON){
        self.id = json["id"].int
        self.jokeOwner = User(data: json["user"])
        self.craete_at = json["created_at"].int
        self.jokeContent = json["content"].string
        self.share_count = json["share_count"].int
        self.up = json["votes","up"].int!
        self.down = json["votes","down"].int!
        self.jokeImage = json["image"].string
        self.imageHeight = json["image_size","m",1].int
        self.imageWidth = json["image_size","m",0].int
        switch json["format"].string!{
            case "word" :jokeType = .Text
            case "image" : jokeType = .Image
            case "video": jokeType = .Video
            default : jokeType = .Text
        }
    }
    
    var  id :Int?
    var  jokeOwner :User?
    var  jokeContent : String?
    var  jokeImage : String?
    var  share_count: Int?
    var  craete_at : Int?
    var  up: Int
    var  down:Int
    var  imageWidth : Int?
    var  imageHeight : Int?
    
}


class User{
    var  name :String?
    var  id : Int?
    var  logo: String?
    init(data:SwiftyJSON.JSON){
        self.name = data["login"].string
        self.id = data["id"].int
        self.logo = data["icon"].string
   }
}

