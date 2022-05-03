//
//  AppDelegate.swift
//  quote
//
//  Created by 景彬 on 2022/4/26.
//  Copyright © 2022 景彬. All rights reserved.
//

import UIKit
//import Kingfisher


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 显示2秒
//        Thread.sleep(forTimeInterval: 2)
//        showLauchImage()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func showLauchImage() {
            let url_string = "http://image.wufazhuce.com/FqWc5Ddw32045kUodXqxIdOujndM"
            
    //        Alamofire.request(url_string,
    //               method: .get,
    //               encoder: JSONParameterEncoder.default).response { response in
    //        debugPrint(response)
            
            
//            AF.request(url_string).response { result in
//                debugPrint(result)
    //        }
    //
    //        AF.request(url_string, method: .get, parameters: nil, encoder: JSONParameterEncoder.default).response{ (response) in
                
    //        }
    //        AF.request(.GET, url_string).responseJSON { (_, _, result) -> Void in
//                if let obj = result.value {
//                    let dict = obj as! NSDictionary
                    
                    let screen_size = UIScreen.main.bounds.size
                    
//                    let img = UIImageView(frame:CGRectMake(0, 0, screen_size.width, screen_size.height))
                    let img = UIImageView(frame:CGRect(x: 0, y: 0, width: screen_size.width, height: screen_size.height))
                    img.image = UIImage(named: "app_lauch")
                    img.backgroundColor = UIColor.black
                    img.contentMode = .scaleAspectFit
        
                    
        let window = UIApplication.shared.keyWindow
        window!.addSubview(img)
//        window.append(img)
                    
//                    let image_url_string = dict["img"] as! String
                    
        
//                    let url = URL(string: url_string)
//                    img.kf.setImage(with: url)
        
        

        
//                    AF.request(url_string).response {result in
//                        if let image_data = result {
//                            img.image = UIImage(data: result)
//                        }
//                    }
        
//        AF.request(url_string).response(completionHandler: { (_,_,data,_) -> Void in
//            if let image_data = data {
//                img.image = UIImage(data: image_data)
//            }
//        })
    //                Alamofire.request(.GET, image_url_string).response(completionHandler: { (_, _, data, _) -> Void in
    //                    if let image_data = data {
    //                        img.image = UIImage(data: image_data)
    //                    }
    //                })
                    
                    let lbl = UILabel(frame:CGRect(x: 0, y:screen_size.height-50, width: screen_size.width, height: 20))
    //                let lbl = UILabel(frame:CGRectMake(0, screen_size.height-50, screen_size.width, 20))
                    lbl.backgroundColor = UIColor.clear
//                    lbl.text = dict["text"] as? String
        lbl.text = "跳过"
                    lbl.textColor = UIColor.gray
                    lbl.textAlignment = NSTextAlignment.center
                    lbl.font = UIFont.systemFont(ofSize: 14)
                    window!.addSubview(lbl)
                    
                    UIView.animate(withDuration: 3,animations:{
                        let height = UIScreen.main.bounds.size.height
                        let rect = CGRect(x: -100, y:-100, width: screen_size.width+200, height: height+200)
    //                    let rect = CGRectMake(-100,-100, screen_size.width+200, height+200)
                        img.frame = rect
                        },completion:{
                            (completion) in
                            
                            if completion {
                                UIView.animate(withDuration: 1,animations:{
                                    img.alpha = 0
                                    lbl.alpha = 0
                                    },completion:{
                                        (completion) in
                                        
                                        if completion {
                                            img.removeFromSuperview()
                                            lbl.removeFromSuperview()
                                        }
                                })
                            }
                    })
                    
                }
                
//            }
//        }

}

