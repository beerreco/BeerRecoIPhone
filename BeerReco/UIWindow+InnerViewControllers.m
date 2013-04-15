//
//  UIWindow+InnerViewControllers.m
//  Pythia
//
//  Created by RLemberg on 2/4/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import "UIWindow+InnerViewControllers.h"

@implementation UIWindow (InnerViewControllers)

- (UIViewController*) topMostController
{
    UIViewController *topController = [self rootViewController];
    
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

-(UIViewController*) shownViewController {
    UIViewController* rootViewController = [self topMostController];
    if ([rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController* navCtrl = (UINavigationController*)rootViewController;
        return navCtrl.topViewController;
    }
    return rootViewController;
    
}

@end
