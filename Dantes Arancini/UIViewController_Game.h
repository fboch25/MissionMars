//
//  UIViewController_Game.h
//  Dantes Arancini
//
//  Created by Frank Joseph Boccia on 1/27/15.
//  Copyright (c) 2015 Frank Joseph Boccia. All rights reserved.
//

#import <UIKit/UIKit.h>

int BallFlight;

@interface UIViewController (){
    
    IBOutlet UIImageView *Orangeball;
    IBOutlet UIButton *StartGame;
    
    NSTimer *BallMovement;
}

-(IBAction)StartGame:(id)sender;
-(void)BallMoving;

@end
