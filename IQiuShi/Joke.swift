//
//  Joke.swift
//  IQiuShi
//
//  Created by swift on 15/11/24.
//  Copyright © 2015年 chensb. All rights reserved.
//

import Foundation
import SwiftyJSON
class Joke{
    enum JokeType{
        case Text
        case Image
        case Video
    }
    
    init(json:SwiftyJSON.JSON){
        self.jokeOwner = User(data: json["user"])
        self.craete_at = json["created_at"].int
        self.jokeContent = json["content"].string
        self.share_count = json["share_count"].int
    }
    var  jokeOwner :User?
    var  jokeContent : String?
    var  share_count: Int?
    var  craete_at : Int?
    
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

