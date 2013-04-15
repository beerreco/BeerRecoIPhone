//
//  UIViewController+ModalPresenter.h
//  3i-Mind
//
//  Created by RLemberg on 2/12/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DimViewTag 1984

@interface UIViewController (ModalPresenter)

- (void)removeFloatingViewControllerFromParent:(void (^)(BOOL finished))completion;

- (void)presentFloatingViewController:(UIViewController*)floatingViewController startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame completion:(void (^)(BOOL finished))completion;

- (int) getRequiredHeight;
- (int) getRequiredWidth;

@end
