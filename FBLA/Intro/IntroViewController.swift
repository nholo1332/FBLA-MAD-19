//
//  IntroViewController.swift
//  FBLA
//
//  Created by Noah Holoubek on 2/4/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import paper_onboarding
import Firebase

class IntroViewController: UIViewController, PaperOnboardingDelegate, PaperOnboardingDataSource {
    
    @IBOutlet var skipButton: UIButton!
    
    //Custom fonts
    static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    
    //Add the following items to the onboarding view (to be shown to the user).
    let onBoardItem: OnboardingItemInfo = OnboardingItemInfo(informationImage: UIImage(named: "completed")!,
                        title: "Hotels",
                        description: "All hotels and hostels are sorted by hospitality rating",
                        pageIcon: UIImage(named: "completed")!,
                        color: UIColor(red: CGFloat(0.40), green: CGFloat(0.56), blue: CGFloat(0.71), alpha: CGFloat(1.00)),
                        titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
        
    let onBoardItem2: OnboardingItemInfo = OnboardingItemInfo(informationImage: UIImage(named: "completed")!,
                        title: "Banks",
                        description: "We carefully verify all banks before add them into the app",
                        pageIcon: UIImage(named: "completed")!,
                        color: UIColor(red: CGFloat(0.40), green: CGFloat(0.69), blue: CGFloat(0.71), alpha: CGFloat(1.00)),
                        titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
        
    let onBoardItem3: OnboardingItemInfo = OnboardingItemInfo(informationImage: UIImage(named: "completed")!,
                        title: "Stores",
                        description: "All local stores are categorized for your convenience",
                        pageIcon: UIImage(named: "completed")!,
                        color: UIColor(red: CGFloat(0.61), green: CGFloat(0.56), blue: CGFloat(0.74), alpha: CGFloat(1.00)),
                        titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)

    override func viewDidLoad() {
        super.viewDidLoad()
        skipButton.isHidden = true
        
        setupPaperOnboardingView()
        
        view.bringSubviewToFront(skipButton)
    }
    
    func setupPaperOnboardingView() {
        //Do the stup for the view.
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        //Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    @IBAction func skipButtonTapped(_: UIButton) {
        //Handle if the user is signed in (bring them home and save that they have finished the onboarding) or if they need to sign in.
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        if Auth.auth().currentUser != nil {
            UserDefaults.standard.set(true, forKey: "oboarding-shown-\(version)")
            let mainVC = MainViewController()
            let navigationVC = UINavigationController(rootViewController: mainVC)
            self.present(navigationVC, animated: true, completion: nil)
        }else{
            UserDefaults.standard.set(true, forKey: "oboarding-shown-\(version)")
            let vcController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.present(vcController, animated: false, completion: nil)
        }
    }
    
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 2 ? false : true
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return [onBoardItem, onBoardItem2, onBoardItem3][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }

}
