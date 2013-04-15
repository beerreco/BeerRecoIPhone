//
//  UIWindow+InnerViewControllers.h
//  Pythia
//
//  Created by RLemberg on 2/4/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (InnerViewControllers)

- (UIViewController*) topMostController;
- (UIViewController*) shownViewController;
@end
