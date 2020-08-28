//
//  FavoriteViewController.swift
//  MusicListApp
//
//  Created by tomo on 2020/07/28.
//  Copyright © 2020 Tomo. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import AVFoundation
import PKHUD

class PlayMusicButton:UIButton{
    
    var params:Dictionary<String,Any>
    
    override init(frame: CGRect) {
        self.params = [:]
        
        super.init(frame:frame)
    }
    required init?(coder adecoder:NSCoder) {
        
        self.params = [:]
        super.init(coder:adecoder)
    }
    
}

class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,URLSessionDownloadDelegate {
    
    
    
    
    
    @IBOutlet weak var favTableView: UITableView!
    
    
    var musicDataModelArray = [MusicDataModel]()
    var artworkUrl = ""
    var previewUrl = ""
    var artistName = ""
    var trackCensoredName = ""
    var imageString = ""
    var userID = ""
    var favRef = Database.database().reference()
    var userName = ""
    
    var player:AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favTableView.allowsSelection = true
        
        if UserDefaults.standard.object(forKey: "userID") != nil {
            
            userID = UserDefaults.standard.object(forKey: "userID") as! String
        }
        
        
        if UserDefaults.standard.object(forKey: "userName") != nil{
            
            userID = UserDefaults.standard.object(forKey: "userName") as! String
            
            self.title = "\(userName)`sMusicList"
        }
        
        favTableView.delegate = self
        favTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .white
        
        
        
        self.title = "\(userName)`sMusicList"
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // インディケーターを回す
        HUD.show(.progress)
        // 値を取得する
        //→usersのIDのしたにあるお気に入りコンテンツ全て
        favRef.child("users").child(userID).observe(.value){
            (snapshot) in
            
            
            
            for child in snapshot.children{
                
                
                let childSnapshot = child as! DataSnapshot
                let musicData = MusicDataModel(snapshot: childSnapshot)
                self.musicDataModelArray.insert(musicData, at: 0)
                self.favTableView.reloadData()
                
            }
            
            
            HUD.hide()
        }
        //これ
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return musicDataModelArray.count
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let musicDataModel = musicDataModelArray[indexPath.row]
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let label1 = cell.contentView.viewWithTag(2) as! UILabel
        let label2 = cell.contentView.viewWithTag(3) as! UILabel
        label1.text = musicDataModel.artistName
        label2.text = musicDataModel.musicName
        
        imageView.sd_setImage(with: URL(string: musicDataModel.imageString), completed: nil)
        
        //再生ボタン
        let playButton = PlayMusicButton(frame: CGRect(x: view.frame.size.width - 60, y: 50, width: 60, height: 60))
        
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTap(_ :)), for: .touchUpInside)
        playButton.params["value"] = indexPath.row
        cell.accessoryView = playButton
        
        
        
        
        return cell
    }
    
    @objc func playButtonTap(_ sender:PlayMusicButton){
        
        //音楽をとめる
        
        if player?.isPlaying == true{
            
            player!.stop()
            
        }
        
        let indexNumber:Int = sender.params["value"] as! Int
        let urlString = musicDataModelArray[indexNumber].preViewURL
        let url = URL(string: urlString!)
        
        print(url!)
        
        //ダウンロード
        downloadMusicURL(url: url!)
        
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        if player?.isPlaying == true{
            
            player!.stop()
            
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func downloadMusicURL(url: URL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {(url, response, error) in
            
            //再生
            self.play(url: url!)
            
            
        })
        
        //これ
        downloadTask.resume()
        
    }
    
    func play(url:URL){
        
        do {
            
            self.player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.play()
            
        } catch let error as NSError {
            
            print(error.localizedDescription)
            
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("Done")
        
    }
    
    
}
