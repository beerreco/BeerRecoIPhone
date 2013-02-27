//
//  AppDelegate.h
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(AppDelegate*)getMainApp;

@property (strong, nonatomic) UIWindow *window;

void RunBlockOnMainQueueAfterDelay(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delay),
                   dispatch_get_main_queue(), block);
}

@end
