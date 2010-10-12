//
//  AFKPageFlipperAppDelegate.h
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-11.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainController.h"


@interface AFKPageFlipperAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	MainController *mainController;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;


@end

