//
//  MainTabBarController.swift
//  MII
//
//  Created by MacDouble on 8/6/18.
//  Copyright © 2018 MacDouble. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController{

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        tabBar.tintColor = .black

        
        //HomeController
        let layout = UICollectionViewFlowLayout()
        let mainController = MainController(collectionViewLayout: layout)
        let homeNavController = UINavigationController(rootViewController: mainController)
        homeNavController.tabBarItem.image = #imageLiteral(resourceName: "tab_home")
        themelizeNavBar(nav: homeNavController)

        //ChatController
        let chatController = MessageController()
        let chatNavController = UINavigationController(rootViewController: chatController)
        chatNavController.tabBarItem.image = #imageLiteral(resourceName: "tab_chat")
        themelizeNavBar(nav: chatNavController)

        //FindController
        let findController = FindController()
        let findNavController = UINavigationController(rootViewController: findController)
        findNavController.tabBarItem.image = #imageLiteral(resourceName: "tab_heart")
        themelizeNavBar(nav: findNavController)

        //AddPostController
        let addPostController = AddPostController()
        let addPostNavController = UINavigationController(rootViewController: addPostController)
        addPostNavController.tabBarItem.image = #imageLiteral(resourceName: "tab_plus")
        themelizeNavBar(nav: addPostNavController)

        
        //UserProfileController
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileController)
        navController.tabBarItem.image = #imageLiteral(resourceName: "tab_profile")
        themelizeNavBar(nav: navController)
        
        //FeedDetailController
        

        viewControllers = [homeNavController, findNavController ,addPostNavController, chatNavController, navController]
        // Do any additional setup after loading the view.
    }
    
    func themelizeNavBar(nav: UINavigationController){
        nav.navigationBar.barTintColor = .theme_color
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.barStyle = UIBarStyle.black
        
    }


}


