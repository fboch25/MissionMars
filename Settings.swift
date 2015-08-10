//
//  Settings.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
var VIBRATION: Bool!
import Foundation
import StoreKit

class Settings: CCNode {
    
    // audio
    let defaults = NSUserDefaults.standardUserDefaults()
    let audio = OALSimpleAudio.sharedInstance()
    // variables
    weak var vibrationToggleButton: CCButton!
    weak var toggleVibrationText: CCLabelTTF!
    weak var musicToggleButton: CCButton!
    weak var toggleMusicText: CCLabelTTF!
    weak var soundEffectsToggleButton: CCButton!
    weak var toggleSoundEffectsText: CCLabelTTF!
    weak var removeAdsButton: CCButton!
    var product_id: NSString?;
    
    // loads setting screen
    func pop(){
        CCDirector.sharedDirector().popScene()
    }
    
    func didLoadFromCCB() {
        //        VIBRATION = true
        
        //Music Load
        if defaults.boolForKey("musicIsSelected") {
            musicToggleButton.selected = true
            toggleMusicText.string = "SOUND: ON"
            audio.bgMuted = false
        } else {
            musicToggleButton.selected = false
            toggleMusicText.string = "SOUND: OFF"
            audio.bgMuted = true
        }
        
        //Vibration Load
        if defaults.boolForKey("vibrationIsSelected") {
            vibrationToggleButton.selected = true
            toggleVibrationText.string = "VIBRATION: OFF"
            VIBRATION = true
        } else {
            vibrationToggleButton.selected = false
            toggleVibrationText.string = "VIBRATION: ON"
            VIBRATION = false
        }
        
////        // In App Purchases
//        
//        product_id = "com.Bocci.MissionMars.removeads";
//        
//        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
//        
//        //Check if product is purchased
//        
//        if (defaults.boolForKey("purchased")){
//            removeAdsButton.selected = true
//        } else if (!defaults.boolForKey("stonerPurchased")){
//            println("false")
//            
//        }
//        
//        if (SKPaymentQueue.canMakePayments())
//        {
//        var productID:NSSet = NSSet(object: self.product_id!);
//        var productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<NSObject>);
//            productsRequest.delegate = (self)
//            productsRequest.start()
//            println("Fetching Products")
//        }else{
//            println("can't make purchases")
//        }
    }
    
    // SoundFunctions
    func toggleMusic() {
        
        var currentState = !defaults.boolForKey("musicIsSelected")
        
        if currentState {
            defaults.setBool(true, forKey: "musicIsSelected")
            musicToggleButton.selected = true
            toggleMusicText.string = "SOUND: ON"
            audio.bgMuted = false
        } else {
            
            defaults.setBool(false, forKey: "musicIsSelected")
            musicToggleButton.selected = false
            toggleMusicText.string = "SOUND: OFF"
            audio.bgMuted = true
        }
    }
    
    func toggleVibration() {
        
        var vibration = !defaults.boolForKey("vibrationIsSelected")
        
        if vibration {
            defaults.setBool(true, forKey: "vibrationIsSelected")
            vibrationToggleButton.selected = true
            toggleVibrationText.string = "VIBRATION: OFF"
            VIBRATION = true
        } else {
            
            defaults.setBool(false, forKey: "vibrationIsSelected")
            vibrationToggleButton.selected = false
            toggleVibrationText.string = "VIBRATION: ON"
            VIBRATION = false
        }
    }

//
//    func buyProduct(product: SKProduct){
//        println("Sending the Payment Request to Apple");
//        var payment = SKPayment(product: product)
//        SKPaymentQueue.defaultQueue().addPayment(payment);
//
//    }
//
//
//    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
//
//        var count : Int = response.products.count
//        if (count>0) {
//            var validProducts = response.products
//            var validProduct: SKProduct = response.products[0] as! SKProduct
//            if (validProduct.productIdentifier == self.product_id) {
//                println(validProduct.localizedTitle)
//                println(validProduct.localizedDescription)
//                println(validProduct.price)
//                buyProduct(validProduct);
//            } else {
//                println(validProduct.productIdentifier)
//            }
//        } else {
//            println("nothing")
//        }
//    
//
//    func request(request: SKRequest!, didFailWithError error: NSError!) {
//        println("Error Fetching product information");
//    }
//
//    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)    {
//        println("Received Payment Transaction Response from Apple");
//
//        for transaction:AnyObject in transactions {
//            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
//                switch trans.transactionState {
//                case .Purchased:
//                    println("Product Purchased");
//                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
//                    defaults.setBool(true , forKey: "purchased")
//
//                    break;
//                case .Failed:
//                    println("Purchased Failed");
//                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
//                    break;
//
//
//
//                case .Restored:
//                    println("Already Purchased");
//                    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
//
//
//                default:
//                    break;
//                    }
//                }
//            }
//        }
//    }
}


