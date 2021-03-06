//
//  iAdHandler.swift
//  ReactionLine
//
//  Created by Aman Sawhney on 7/19/15.
//  Copyright (c) 2015 AmanSawhney. All rights reserved.
//

import Foundation
import iAd

enum BannerPosition {
    case Top, Bottom
}

class iAdHandler: NSObject {
    
    // MARK: Variables
    
    let view = CCDirector.sharedDirector().parentViewController!.view // Returns a UIView
    
    var adBannerView = ADBannerView(frame: CGRect.zero)
    var bannerPosition: BannerPosition = .Top
    
    var interstitial = ADInterstitialAd()
    var interstitialAdView: UIView = UIView()
    var interstitialActionIndex = 0
    
    var closeButton: UIButton!
    
    // MARK: Singleton
    
    class var sharedInstance : iAdHandler {
        struct Static {
            static let instance : iAdHandler = iAdHandler()
        }
        return Static.instance
    }
    
    
    // MARK: Banner Ad Functions
    
    /**
    Sets the position of the soon-to-be banner ad and attempts to load a new ad from the iAd network.
    
    - parameter bannerPosition:  the `BannerPosition` at which the ad should be positioned initially
    */
    func loadAds(bannerPosition bannerPosition: BannerPosition) {
        self.bannerPosition = bannerPosition
        
        if bannerPosition == .Top {
            adBannerView.center = CGPoint(x: adBannerView.center.x, y: -(adBannerView.frame.size.height / 2))
        }
        else {
            adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height + (adBannerView.frame.size.height / 2))
        }
        
        adBannerView.delegate = self
        adBannerView.hidden = true
        adBannerView.backgroundColor = UIColor.clearColor()
        view.addSubview(adBannerView)
    }
    
    /**
    Repositions the `adBannerView` to the designated `bannerPosition`.
    
    - parameter bannerPosition:  the `BannerPosition` at which the ad should be positioned
    */
    func setBannerPosition(bannerPosition bannerPosition: BannerPosition) {
        self.bannerPosition = bannerPosition
    }
    
    /**
    Displays the `adBannerView` with a short animation for polish.
    
    If a banner ad has not been successfully loaded, nothing will happen.
    */
    func displayBannerAd() {
        
        CCDirector.sharedDirector().stopAnimation()
        
        if adBannerView.bannerLoaded {
            adBannerView.hidden = false
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                if self.bannerPosition == .Top {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: (self.adBannerView.frame.size.height / 2))
                }
                else {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: self.view.bounds.size.height - (self.adBannerView.frame.size.height / 2))
                }
            })
        }
        else {
            print("Did not display ads because banner isn't loaded yet!")
        }
    }
    
    /**
    Hides the `adBannerView` with a short animation for polish.
    
    If a banner ad has not been successfully loaded, nothing will happen.
    */
    func hideBannerAd() {
        if adBannerView.bannerLoaded {
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                if self.bannerPosition == .Top {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: -(self.adBannerView.frame.size.height / 2))
                }
                else {
                    self.adBannerView.center = CGPoint(x: self.adBannerView.center.x, y: self.view.bounds.size.height + (self.adBannerView.frame.size.height / 2))
                }
            })
            delay(0.5) {
                self.adBannerView.hidden = true
            }
        }
    }
    
    
    // MARK: Interstitial Functions
    
    /**
    Attempts to load an interstitial ad.
    */
    func loadInterstitialAd() {
        interstitial.delegate = self
    }
    
    /**
    Displays the `interstitial`.
    
    If an interstitial has not been successfully loaded, nothing will happen.
    */
    func displayInterstitialAd() {
        
        if interstitial.loaded == true {
            
            view.addSubview(interstitialAdView)
            interstitial.presentInView(interstitialAdView)
            UIViewController.prepareInterstitialAds()
            
            CCDirector.sharedDirector().stopAnimation()
            
            closeButton = UIButton(frame: CGRect(x: interstitialAdView.frame.width - 550, y: interstitialAdView.frame.height - 300, width: 25, height: 25))
            print(closeButton.frame, terminator: "")
            
            closeButton.setBackgroundImage(UIImage(named: "close"), forState: UIControlState.Normal)
            closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchDown)
            self.view.addSubview(closeButton)
            
            print("Interstitial loaded!", terminator: "")
        }
        else {
            loadInterstitialAd()
            print("Interstitial not loaded yet!", terminator: "")
        }
        
    }
    
    /**
    Closes the `interstitial`.
    
    It closes the `interstitialAdView` and `closeButton` sub-views.
    */
    func close(){
        interstitialAdView.removeFromSuperview()
        closeButton.removeFromSuperview()
        CCDirector.sharedDirector().startAnimation()
    }
    
    // MARK: Convenience Functions
    
    /**
    When called, delays the running of code included in the `closure` parameter.
    
    - parameter delay:  how long, in milliseconds, to wait until the program should run the code in the closure statement
    */
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

extension iAdHandler: ADInterstitialAdDelegate {
    
    /**
    Called whenever a interstitial successfully loads.
    */
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        interstitialAdView = UIView()
        interstitialAdView.frame = self.view.bounds
        
        print("Succesfully loaded interstitital!", terminator: "")
    }
    
    /**
    Called whenever the interstitial's action finishes; e.g.: the user has already clicked on the ad and decides to exit out or the ad campaign finishes.
    */
    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
        interstitialAdView.removeFromSuperview()
        closeButton.removeFromSuperview()
    }
    
    /**
    Called whenever an interstitial ad is about to be displayed.
    */
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    /**
    Called whenever an interstitial ad unloads automatically.
    */
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        interstitialAdView.removeFromSuperview()
        closeButton.removeFromSuperview()
    }
    
    /**
    Called when a interstitial was unable to be loaded.
    */
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        print("Was not able to load an interstitial with error: \(error)", terminator: "")
    }
    
}

extension iAdHandler: ADBannerViewDelegate {
    
    /**
    Called whenever a banner ad successfully loads.
    */
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print("Successfully loaded banner!", terminator: "")
    }
    
    /**
    Called when a banner ad was unable to be loaded.
    */
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print("Was not able to load a banner with error: \(error)", terminator: "")
        adBannerView.hidden = true
    }
    
}