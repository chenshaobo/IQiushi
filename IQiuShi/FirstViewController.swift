//
//  FirstViewController.swift
//  IQiuShi
//
//  Created by swift on 15/11/24.
//  Copyright © 2015年 chensb. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FirstViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, PlayerDelegate{
    
    
    
    @IBOutlet weak var jokeTableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
        }()
    
    var jokes = [Joke]()
    var  videoPlayer = Player()
    var curPage = 1
    let pageSize = 30
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let nib = UINib(nibName: "JokeCell", bundle: nil)
        self.jokeTableView.registerNib(nib, forCellReuseIdentifier: "JokeCell")
    
        //添加下拉刷新
        self.jokeTableView.addSubview(refreshControl)
        jokeTableView.delegate = self
        jokeTableView.dataSource  = self
        initData()
        jokeTableView.estimatedRowHeight = jokeTableView.rowHeight
        jokeTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        
        super.viewWillAppear(animated)
       
    }
    
    func initData(){
        self.curPage = 1
        self.jokes = [Joke]()
        self.jokeTableView.reloadData()
        getJokeData()
    }
    
    func getJokeData(){
        dispatch_async(dispatch_get_main_queue()){
            Alamofire.request(.GET,TEXT_JOKE,parameters:["page":self.curPage,"count":self.pageSize])
                .responseJSON
                {
                    response in
                    let json = SwiftyJSON.JSON(response.result.value!)
                    for (_,item):(String,SwiftyJSON.JSON) in json["items"]{
                        let joke = Joke(json:item)
                        self.jokes.append(joke)
                    }
                    self.jokeTableView.reloadData()
            }
        }
        self.curPage = self.curPage + 1
        print("curpage:\(curPage)   ")
    }
    
    //上拉刷新拉获取数据
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.refreshControl.beginRefreshing()
        self.refreshControl.attributedTitle = NSAttributedString(string:"正在刷新。。")
        print("update fresh")
        initData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jokes.count
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("select channel \(indexPath.row)")
//        _ = tableView.cellForRowAtIndexPath(indexPath) as! JokeCell
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JokeCell", forIndexPath: indexPath) as! JokeCell
        cell.joke = jokes[indexPath.row]
        cell.viewController = self
        //快到底部 加载 下一页的内容
        let index =  Int(Double(jokes.count) * 0.9)
        if index == indexPath.row{
            getJokeData()
        }
        return cell
    }
    
    func playerVideo(url:String,cell:JokeCell   ){
        self.videoPlayer.setUrl(NSURL(string:url)!)
        self.videoPlayer.delegate = self
        self.videoPlayer.view.frame = cell.bounds
        
        self.addChildViewController(self.videoPlayer)
        cell.addSubview(self.videoPlayer.view)
        self.videoPlayer.didMoveToParentViewController(self)
        self.videoPlayer.playFromBeginning()
    }
    
    func playerReady(player: Player) {
    }
    
    func playerPlaybackStateDidChange(player: Player) {
    }
    
    func playerBufferingStateDidChange(player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {
    }
    
    func playerPlaybackDidEnd(player: Player) {
        self.videoPlayer.setupPlayerItem(nil)
        self.videoPlayer.view.removeFromSuperview()
    }
}

