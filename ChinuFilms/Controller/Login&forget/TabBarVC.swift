//
//  TabBarVC.swift
//  SanskarEP
//
//  Created by Warln on 21/02/22.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setup() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let home = story.instantiateViewController(withIdentifier: "HomeVc") as! HomeVc
        let profile = story.instantiateViewController(withIdentifier: "ProfileVc") as! ProfileVc
        
        let nav1 = UINavigationController(rootViewController: home)
        //let nav2 = UINavigationController(rootViewController: profile)
        
        nav1.setNavigationBarHidden(true, animated: true)
      //  nav2.setNavigationBarHidden(true, animated: true)
        
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 1)
      //  nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        UITabBar.appearance().tintColor = .systemRed
        setViewControllers([nav1], animated: false)
        
    }

}
