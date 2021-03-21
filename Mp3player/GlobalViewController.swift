//
//  GlobalViewController.swift
//  Mp3player
//
//  Created by Koushik Das Sharma on 20/03/21.
//  Copyright © 2021 Koushik Das Sharma. All rights reserved.
//

import UIKit
//import Alamofire
//import NVActivityIndicatorView
import Foundation

@available(iOS 12.0, *)
class GlobalViewController: UIViewController{
    
    static let Isiphone5 = (UIScreen.main.bounds.size.height==568) ? true : false
    static let Isiphone6 = (UIScreen.main.bounds.size.height==667) ? true : false
    static let Isiphone6Plus = (UIScreen.main.bounds.size.height==736) ? true : false
    static let IsiphoneX = (UIScreen.main.bounds.size.height==812) ? true : false
    static let IsiphoneXR = (UIScreen.main.bounds.size.height>=896) ? true : false
    static let iPad_Pro_12_9 = (UIScreen.main.bounds.size.height==1366) ? true : false
    static let iPad_10_5_inch = (UIScreen.main.bounds.size.height==1112) ? true : false
    static let iPad_10_2_inch = (UIScreen.main.bounds.size.height==1080) ? true : false
    static let iPad_9_7_inch_Retina = (UIScreen.main.bounds.size.height==1024) ? true : false
    
    let FullWidth = UIScreen.main.bounds.size.width
    let FullHeight = UIScreen.main.bounds.size.height
    
    let globalDispatchgroup = DispatchGroup()
    var globalJson: NSDictionary!
    static let GLOBALAPI1 = "https://www.go2uni.co/api/"
   
    
    private var _orientations = UIInterfaceOrientationMask.portrait
    
    override var shouldAutorotate: Bool {
        
        return false
        
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get { return self._orientations }
        set { self._orientations = newValue }
    }
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.Portrait
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @objc func messageNotificationIdentifier(notification: NSNotification){
        self.showToast(message: "Download completed", font: .systemFont(ofSize: 12.0))
        NotificationCenter.default.post(name: Notification.Name("Downlodecompleted"), object: nil)
    }
    @objc func Already_exit(notification: NSNotification){
        self.showToast(message: "Already exit", font: .systemFont(ofSize: 12.0))
        NotificationCenter.default.post(name: Notification.Name("Downlodecompleted"), object: nil)
    }
    @objc func reatch_limit(notification: NSNotification){
        self.showToast(message: "You can download maximum 5 videos for ofline mode", font: .systemFont(ofSize: 12.0))
        NotificationCenter.default.post(name: Notification.Name("Downlodecompleted"), object: nil)
    }
    
    
    
    // MARK:- // calenderbuttonaction
    
    @objc func calenderbuttonaction()
    {
//        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "userViewController") as! userViewController
//        self.navigationController?.pushViewController(profileVC, animated: false)
        
    }
   
    // MARK:- // contectbuttonaction
    @objc func contectbuttonaction()
    {
//        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "hostViewController") as! hostViewController
//        self.navigationController?.pushViewController(profileVC, animated: false)
        
    }
    
    
//    // MARK:- // Current view controller
//
//    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
//        if let navigationController = controller as? UINavigationController
//        {
//            return topViewController(controller: navigationController.visibleViewController)
//        }
//
//        return controller
//    }
    
    
    // MARK: - // function TopViewController


    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    
    func CallAPI(urlString : String,param : String, completion : @escaping () -> ())
            
        {
           
        self.globalDispatchgroup.enter()
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(size: CGSize(width: 40.0/320 * FullWidth, height: 40.0/320 * FullWidth), message: "", messageFont: UIFont.init(name: "", size: 14), messageSpacing: 1.0, type: .circleStrokeSpin, color: UIColor.yellow, padding: 0.0, backgroundColor: UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5), textColor: .black)) //(displayP3Red: 0/255, green: 135/255, blue: 228/255, alpha: 1)
        if Connectivity.isConnectedToInternet() {
            var localTimeZoneName: String { return TimeZone.current.identifier }
            print(localTimeZoneName)
            let  urlstr = URL(string: GlobalViewController.GLOBALAPI1 + urlString)!   //change the url
            let parameters = param
                
            print("Parameters are : " , parameters)
            print("URL : ", "\(urlstr)" + "?" + parameters)
            let session = URLSession.shared
            session.configuration.timeoutIntervalForRequest = 120
            var request = URLRequest(url: urlstr)
            request.httpMethod = "POST" //set http method as POST
            do {
                request.httpBody = param.data(using: String.Encoding.utf8)
                //request.addValue(localTimeZoneName, forHTTPHeaderField: "timezone")
            }
            print("URL : ", "\(urlstr)" + "?" + parameters)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    
                guard error == nil else {
                        
                    DispatchQueue.main.async {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            
                        }
                        
                        return
                        
                    }
                if let response = response as? HTTPURLResponse{
                    if response.statusCode == 200{
                        DispatchQueue.main.async {
                            guard let data = data else {
                                DispatchQueue.main.async { NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                                        
                                }
                                return
                                                    
                            }
                                                
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                                print("JSon Response: " , json)
                                self.globalJson = json.copy() as? NSDictionary //print("helooooooooooo",self.self.globalJson.count)
                                DispatchQueue.main.async {
                                    completion()
                                                            
                                }
//
                            }
                                                    
                        } catch let error {
                            print(error.localizedDescription)
                                DispatchQueue.main.async {      //self.globalDispatchgroup.leave()     NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                                }
                            }
                        }
                    }
                }
            })
            task.resume()
        }
        else
        {
            DispatchQueue.main.async {
                self.globalDispatchgroup.leave()
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
                
        }
            
    }
    
    func CallApiGET(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        self.globalDispatchgroup.enter()
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(size: CGSize(width: 40.0/320 * FullWidth, height: 40.0/320 * FullWidth), message: "", messageFont: UIFont.init(name: "", size: 14), messageSpacing: 1.0, type: .circleStrokeSpin, color: UIColor.yellow, padding: 0.0, backgroundColor: UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5), textColor: .black))
        if Connectivity.isConnectedToInternet(){
            var components = URLComponents(string: GlobalViewController.GLOBALAPI1 + url)!
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            let request = URLRequest(url: components.url!)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,                            // is there data
                    let response = response as? HTTPURLResponse,  // is there HTTP response
                    (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                    error == nil else {                           // was there no error, otherwise ...
                        completion(nil, error)
                        return
                }
                
                let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
                completion(responseObject, nil)
            }
            task.resume()
        }
        else{
            DispatchQueue.main.async {
                self.globalDispatchgroup.leave()
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
            
        }
    }

    
   //MARK:- addtolocal
    func addtolocal(ispath:String,useriddirectory:String,directoryname:String,file_typefile_name:String,data: Data, completion : @escaping () -> ()) {

         let fm = FileManager.default
               let path = ispath

               do {
                var items = try fm.contentsOfDirectory(atPath: path)
                   //print(items)
                if items.count <= 5{
                    let dirPaths = fm.urls(for: .documentDirectory, in: .userDomainMask)
                    let docsDir = dirPaths[0].appendingPathComponent(useriddirectory).appendingPathComponent(directoryname).appendingPathComponent(file_typefile_name)
                    if !FileManager.default.fileExists(atPath: docsDir.path){
                        if let _ = try? data.write(to: docsDir, options: Data.WritingOptions.atomic){
                            //print("\n\nurl data written\n\n")
                            
                            completion()
                            //
                        }
                        else{
                            
                            print("\n\nerror again\n\n")
                            
                            //                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        }
                    }else{
                        //                               NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        //globalFunctions.share.ShowAlertMessage(title: "", message: "Already exit", viewController: self)
                        NotificationCenter.default.post(name: Notification.Name("Already_exit"), object: nil)
                    }
                    for item in items {
                        
                        // print("Found \(item)")
                        // self.imagearray.append("\(item!)")
                    }
                    //}
                }else{
//                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    //globalFunctions.share.ShowAlertMessage(title: "", message: "reatch limit", viewController: self)
                      print("reatch limit")
                    NotificationCenter.default.post(name: Notification.Name("reatch_limit"), object: nil)
                   }
                   
               } catch let error {
                   print("Error: \(error.localizedDescription)")
               }
    }
    //MARK:- readfromlocal
    func readfromlocal(){
        
    }
    //MARK:- deletetolocal
     func deletetolocal(useriddirectory:String,directoryname:String,file_typefile_name:String, completion : @escaping () -> ()) {

          let fm = FileManager.default
            let dirPaths = fm.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDir = dirPaths[0].appendingPathComponent(useriddirectory).appendingPathComponent(directoryname).appendingPathComponent(file_typefile_name)
        if FileManager.default.fileExists(atPath: docsDir.path){
            do {
                    try fm.removeItem(at: docsDir)
                        completion()
                
            
                } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
        }else{
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                globalFunctions.share.ShowAlertMessage(title: "", message: "Already exit", viewController: self)
            }
     }
    
    
    
    //MARK:- imageOrientation
   func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
    
    //MARK:- Global Alomo Api Function

      func CallAPI1(urlString : String, param : [String: Any],image :UIImage, completion : @escaping () -> ()){

          self.globalDispatchgroup.enter()
            guard let imgData = image.jpegData(compressionQuality: 0.2) else { return }
           NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData.init(size: CGSize(width: 40.0/320 * FullWidth, height: 40.0/320 * FullWidth), message: "", messageFont: UIFont.init(name: "", size: 14), messageSpacing: 1.0, type: .circleStrokeSpin, color: UIColor.yellow, padding: 0.0, backgroundColor: UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5), textColor: .black))

          if Connectivity.isConnectedToInternet(){

              let urlstr = GlobalViewController.GLOBALAPI1 + urlString

              print("urlstr:",urlstr)
            AF.session.configuration.timeoutIntervalForRequest = 120
              let parameters: [String: Any] = param
                AF.upload(multipartFormData: { multiPart in
                    for p in parameters {
                        multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                        print(parameters)
                    }
                   multiPart.append(imgData, withName: "Profile", fileName: "Profile.jpg", mimeType: "image/jpg")
                }, to: urlstr, method: .post).uploadProgress(queue: .main, closure: { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                }).responseJSON(completionHandler: { data in
                    print("upload finished: \(data)")
                   if data.response?.statusCode == 200{
                    self.globalJson = data.value as! NSDictionary
                    DispatchQueue.main.async {
                        
                        self.globalDispatchgroup.leave()
                        
                        completion()
                        
                    }
                    //print(self.globalJson)
//                    if "\(self.globalJson["ErrorCode"] ?? "")".elementsEqual("200"){
//                        //print(self.globalJson)
//                            DispatchQueue.main.async {
//
//                                self.globalDispatchgroup.leave()
//
//                                completion()
//
//                            }
//                        }else{
//
//                        }
                   }else{
                     DispatchQueue.main.async {
                        
                        self.globalDispatchgroup.leave()
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                        
                        }
                    }
                })
          }
          else
          {
              DispatchQueue.main.async {

                  self.globalDispatchgroup.leave()
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
          }
      }
    
    
    
 func UIColorFromRGB(rgbValue: UInt) -> UIColor {
     return UIColor(
         red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
         green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
         blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
         alpha: CGFloat(1.0)
     )
 }
    
    func getDateinMyFormat(date: String) -> String{
        let tempDate = date.components(separatedBy: " ")
        let temp = ((tempDate[0].components(separatedBy: "/"))[0])
        if let monthNumber = Int(temp){
            let fmt = DateFormatter()
            fmt.dateFormat = "MMM"
            let month = fmt.monthSymbols[monthNumber - 1]
            //print(month)
            let finalDate = "\((tempDate[0].components(separatedBy: "/"))[1])\(month), \((tempDate[0].components(separatedBy: "/"))[2])"
            return finalDate
        }
        else{
            return " "
        }
        
    }

}


// MARK:- // Anchor Functions

extension UIView {
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
extension UINavigationController {

    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }

}
@available(iOS 12.0, *)
@available(iOS 12.0, *)
extension GlobalViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: 10 , y: self.view.frame.size.height-100, width: self.view.frame.size.width-20, height: 40))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.numberOfLines = 0
    
    let titleFont = UIFont(name: "MyriadPro-Regular", size: CGFloat(globalFunctions.share.Get_fontSize(sizes: 12.0)))
    toastLabel.font = titleFont
    //globalFunctions.share.getfontforUIlebel(UIlebel: toastLabel, sizes: 12.0)
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 5.0, delay: 1.0, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }

