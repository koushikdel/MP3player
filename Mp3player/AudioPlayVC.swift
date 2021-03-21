//
//  ViewController.swift
//  Mp3player
//
//  Created by Koushik Das Sharma on 20/03/21.
//  Copyright © 2021 Koushik Das Sharma. All rights reserved.
//

import UIKit

import AVFoundation
//import NVActivityIndicatorView
//import Alamofire

@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
@available(iOS 12.0, *)
class AudioPlayVC: UIViewController{
    
    
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var showHideBtnout: UIButton!
    
    @IBOutlet weak var buttonConstant: NSLayoutConstraint!
  
    @IBOutlet weak var downlodebtn: UIButton!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var list: UITableView!
    var player: AVPlayer!
    var playerLayer: AVAudioPlayer!
    var videoURL: URL?
    var imageurl: URL?
    var isVideoPlaying = false
    var isVideoMute = false
    var isFullscreen = false
    var isHideBottom = false
    let fullHeight = UIScreen.main.bounds.size.height
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var imagearray = [String]()
    var is_enter : Bool = false
    var viewcon = UIViewController()
    var timer = Timer()
    var user_path : String!
    var urlpath: String!
    var imageurlpath: String!
    var vediourlpath: String!
    var userid : String!
    var imagetitle: String!
    var imagedata: Data!
    var videoId: String!
    var videoDetailsDic: NSDictionary?
    var Reating : Double!
    var downloadURL: URL?
    
    @IBOutlet weak var videoControlView: UIView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    
    //Custom View outlet
    
    private var _orientations = UIInterfaceOrientationMask.portrait
   var urlarray = [listDataStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlarray.append(listDataStruct(name: "Music 1", Url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"))
        urlarray.append(listDataStruct(name: "Music 2", Url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"))
        urlarray.append(listDataStruct(name: "Music 3", Url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3"))
        
        list.dataSource = self
        list.delegate = self
        list.reloadData()
            //geturl(utl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
            
            //storeAndShare(withURLString: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
        
        
        
        
        
        //IQKeyboardManager.shared.enableAutoToolbar = false
        //IQKeyboardManager.shared.enable = false
        buttonConstant.constant = fullHeight - (140/568.0*fullHeight + 16.0)
        //print(fullHeight)
        //print(self.headerView.frame.size.height + 180.0/568.0*fullHeight)
        
        //print(userid!)
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.videoControlView.isHidden = false
        self.view.bringSubviewToFront(videoControlView)
        self.isHideBottom = false
        playPauseOut.setImage(UIImage(named: "play"), for: .normal)
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.enable = true
//    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    //MARK:- Customize View
    func retrivedirectory(Filename:String,completion : @escaping () -> ()){
        let filemgr = FileManager.default

        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDir = dirPaths[0].appendingPathComponent(userid).appendingPathComponent(Filename).path
        //print(docsDir)
        urlpath = "\(docsDir)"
        completion()
    }
    //MARK:- Customize View
    public func SetTableheight(table: UITableView , heightConstraint: NSLayoutConstraint) {
        
        var setheight: CGFloat  = 0
        table.frame.size.height = 3000
        
        for cell in table.visibleCells {
            setheight += cell.bounds.height
        }
        
        print(CGFloat(setheight))
        
        heightConstraint.constant = CGFloat(setheight)
    }
    //MARK:- Customize View
    
    @IBAction func hideButtonView(_ sender: UIButton) {
        if isHideBottom{
            self.videoControlView.isHidden = false
            self.isHideBottom = false
        }
        else{
            self.videoControlView.isHidden = true
            self.isHideBottom = true
       }
        
    }
    
    func showActivityIndicatory(uiView: UIView) {
        
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.style =
            UIActivityIndicatorView.Style.whiteLarge
        uiView.addSubview(actInd)
        actInd.translatesAutoresizingMaskIntoConstraints = false
        actInd.centerXAnchor.constraint(equalTo: self.videoView.centerXAnchor).isActive = true
        actInd.centerYAnchor.constraint(equalTo: self.videoView.centerYAnchor).isActive = true
        
        actInd.startAnimating()
    }
    //MARK:- Customize View
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player.currentItem else {return}
            //self?.timeSlider.minimumValue = 0.0
            //print(Float(self!.player.currentItem!.duration.seconds))
            //globalFunctions.share.ShowAlertMessage(title: "\((self!.player.currentItem!.duration.seconds))", message: "", viewController: self!)
            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
            self?.timeSlider.maximumValue = Float((currentItem.duration.seconds))
            
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.getTimeString(from: currentItem.currentTime())
            if currentItem.duration == self?.player.currentTime(){
                self?.videoControlView.isHidden = false
                self?.isHideBottom = false
            }
        })
    }
    //MARK:- Customize View
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    //MARK:- Customize View
    @objc func updateCounting(){
        if self.isVideoPlaying{
            self.actInd.stopAnimating()
            playPauseOut.setImage(UIImage(named: "pause"), for: .normal)
        }
        else{
            playPauseOut.setImage(UIImage(named: "play"), for: .normal)
        }
        if self.player.currentItem?.currentTime().seconds == 0.0 {
            self.videoControlView.isHidden = false
            self.isHideBottom = false
        }else{
//                self.videoControlView.isHidden = true
//                self.isHideBottom = true
        }
        if self.player.currentItem?.duration == self.player.currentTime(){
            timer.invalidate()
            //self.videoControlView.isHidden = false
//            self.isHideBottom = false
        }
    }
//    func updateCounting(){
//        NSLog("counting..")
//    }
    //MARK:- Customize View
    @IBOutlet weak var playPauseOut: UIButton!
    @IBAction func playPressed(_ sender: UIButton) {
        if isVideoPlaying {
            if videoURL == nil{
                
            }else{
                player.pause()
                
                //sender.setTitle("Play", for: .normal)
                playPauseOut.setImage(UIImage(named: "play"), for: .normal)
            }
            
        }else {
            if videoURL == nil{
                
            }else{
                player.play()
                
                //sender.setTitle("Pause", for: .normal)
                playPauseOut.setImage(UIImage(named: "pause"), for: .normal)
            }
            
        }
        isVideoPlaying = !isVideoPlaying
        
    }
    
//    @IBAction func fullscreenBtnAct(_ sender: Any) {
//        askQuestionTextFld.resignFirstResponder()
//        if isFullscreen{
//            self.detailsView.isHidden = false
//            buttonConstant.constant = fullHeight - (self.headerView.frame.size.height + 180.0/568.0*fullHeight + 16.0)
//            self.headerView.isHidden = false
//            _orientations = UIInterfaceOrientationMask.portrait
//            let value = UIInterfaceOrientation.portrait.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//            UINavigationController.attemptRotationToDeviceOrientation()
//            self.MainView.backgroundColor = UIColorFromRGB(rgbValue: 0xF4B136)
//
//        }
//        else{
//            self.detailsView.isHidden = true
//            buttonConstant.constant = 0
//            self.headerView.isHidden = true
//            let value = UIInterfaceOrientation.landscapeRight.rawValue
//            _orientations = UIInterfaceOrientationMask.landscapeRight
//            UIDevice.current.setValue(value, forKey: "orientation")
//            UINavigationController.attemptRotationToDeviceOrientation()
//            self.MainView.backgroundColor = UIColor.black
//
//        }
//        //self.playerLayer.videoGravity = .resizeAspectFill
//        self.playerLayer.frame = self.videoView.bounds
//        self.isFullscreen = !self.isFullscreen
////        if (UIDevice.current.orientation.isLandscape) {
////
////            DispatchQueue.main.async {
////                self.view.didAddSubview(self.videoView)
////                self.playerLayer = AVPlayerLayer(player: self.player!)
////                self.playerLayer?.frame = self.view.frame
////                self.playerLayer?.videoGravity = .resizeAspectFill
////                self.view.layer.addSublayer(self.playerLayer!)
////
////            }
////        }
//    }
    //MARK:- UIColorFromRGB
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    //MARK:- muteOut
    @IBOutlet weak var muteOut: UIButton!
    @IBAction func btnMute(_ sender: UIButton) {
        if isVideoMute{
            player.isMuted = false
            muteOut.setImage(UIImage(named: "speaker"), for: .normal)
        }
        else{
            player.isMuted = true
            muteOut.setImage(UIImage(named: "mute"), for: .normal)
        }
        isVideoMute = !isVideoMute
        
    }
   
    //MARK:- storeAndShare
    func storeAndShare(withURLString: String) {

                let session = URLSession.shared
                DispatchQueue.global(qos: .background).async {
                    var request = URLRequest(url: URL(string: withURLString)!)
                    request.httpMethod = "GET"
                    _ = session.dataTask(with: request, completionHandler: { (data, response, error) in
                        if(error != nil){
                            print("\n\nsome error occured\n\n")
                            return
                        }
                        if let response = response as? HTTPURLResponse{
                            if response.statusCode == 200{
                                DispatchQueue.main.async {
                                    if let data = data{

                                        DispatchQueue.main.async(execute: {

                                            })


                                }

                                    //end if let data
                                }//end dispatch main
                            }//end if let response.status
                        }
                    }).resume()
                }

    }
    //MARK:- forwardPressed
    @IBAction func forwardPressed(_ sender: Any) {
        if videoURL == nil{
            
        }else{
            guard let duration = player.currentItem?.duration else {return}
            let currentTime = CMTimeGetSeconds(player.currentTime())
            let newTime = currentTime + 5.0

            if newTime < (CMTimeGetSeconds(duration) - 5.0) {
                let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
                player.seek(to: time)
            }
        }
        
    }
    //MARK:- backwardsPressed
    @IBAction func backwardsPressed(_ sender: Any) {
        if videoURL == nil{
            
        }else{
            let currentTime = CMTimeGetSeconds(player.currentTime())
            var newTime = currentTime - 5.0

            if newTime < 0 {
                newTime = 0
            }
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
            player.seek(to: time)
        }
        
    }
    //MARK:- geturl
    func geturl(utl:String){
       
        DispatchQueue.main.async() {
           self.videoURL = URL(string: utl)
            if let URL = (self.videoURL) {
                
                if let thumbnailImage = self.getThumbnailImage1(forUrl: URL) {
                    var image = UIImage()
                    image = thumbnailImage
                    self.imagedata = image.jpegData(compressionQuality: 0.5)
               }
                
                
                //let url = URL(string: URL)!
                if self.isVideoPlaying{
                    self.player.pause()
                    self.playPauseOut.setImage(UIImage(named: "play"), for: .normal)
                    self.player = AVPlayer(url: self.videoURL!)
                    self.player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
                    self.player.play()
                    self.playPauseOut.setImage(UIImage(named: "pause"), for: .normal)
                    self.isVideoPlaying = true
                    self.is_enter = true
                    self.addTimeObserver()
                    self.scheduledTimerWithTimeInterval()
                    
                }else{
                    self.player = AVPlayer(url: self.videoURL!)
                    self.player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
                    self.player.play()
                    self.playPauseOut.setImage(UIImage(named: "pause"), for: .normal)
                    self.isVideoPlaying = true
                    self.is_enter = true
                    self.addTimeObserver()
                    self.scheduledTimerWithTimeInterval()
                }
                
                
                
            }
            else {
                self.isVideoPlaying = false
                let alert = UIAlertController(title: "Error", message: "Invalid video URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
    }
    //MARK:- getThumbnailImage
    func getThumbnailImage(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    //MARK:- getThumbnailImage1
    func getThumbnailImage1(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        print(CMTimeMake(value: 10000, timescale: 600).seconds)
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 10000, timescale: 600) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    //MARK:- sliderValueChanged
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
        
    }
    //MARK:- observeValue
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.durationLabel.text = "/" + getTimeString(from: player.currentItem!.duration)
        }
        
    }
    //MARK:- getTimeString
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        }else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
}
//MARK:- UITableViewDelegate
extension AudioPlayVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Urltableview") as! Urltableview
        cell.lable.text = "\(urlarray[indexPath.row].name ?? "")"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        geturl(utl: "\(urlarray[indexPath.row].Url ?? "")")
    }
    
}
//MARK:- listDataStruct
struct listDataStruct {
    var name: String?
    var Url: String?
    
    init(name: String,Url: String){
        self.name = name
        self.Url = Url
    }
}
class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow(color: UIColor.gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3)
        }
    }
    
    private func setupShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1) {
        self.layer.cornerRadius = 10
        layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
