//
//  UIViewController+ModalPresenter.m
//  3i-Mind
//
//  Created by RLemberg on 2/12/13.
//  Copyright (c) 2013 ThreeMind. All rights reserved.
//

#import "UIViewController+ModalPresenter.h"

@implementation UIViewController (ModalPresenter)

- (void)removeFloatingViewControllerFromParent:(void (^)(BOOL finished))completion
{
    [self willMoveToParentViewController:nil];
    
    CGRect endFrame = self.view.frame;
    endFrame.origin.y = -endFrame.size.height;
    
    UIView* dimView = [self.view.superview viewWithTag:DimViewTag];
    
    [UIView animateWithDuration:0.5
						  delay:0.0
						options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 [self.view setFrame:endFrame];
                         [dimView setAlpha:0.0];
					 }
					 completion:^(BOOL finished) {
                         [dimView removeFromSuperview];
                         [self.view removeFromSuperview];
                         [self  removeFromParentViewController];
                         
                         if (completion)
                         {
                             completion(finished);
                         }
					 }];
}

- (void)presentFloatingViewController:(UIViewController*)floatingViewController  startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame completion:(void (^)(BOOL finished))completion
{
    CGRect dimFrame = self.view.bounds;
    
    UIView* dimView = [[UIView alloc] initWithFrame:dimFrame];
    dimView.backgroundColor = [UIColor blackColor];
    dimView.alpha = 0;
    dimView.tag = DimViewTag;
    
    [self.view addSubview:dimView];
        
    [self addChildViewController:floatingViewController];
    
    [self.view addSubview:floatingViewController.view];
    [floatingViewController.view setFrame:startFrame];
    [floatingViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [floatingViewController.view setFrame:endFrame];
                         [dimView setAlpha:0.5];
                     }
                     completion:^(BOOL finished) {
                         if (completion)
                         {
                             completion(finished);
                         }
                     }];
}

- (int) getRequiredHeight
{
    int height = self.view.frame.size.height;
    
    if (self.navigationController != nil && !self.navigationController.navigationBarHidden)
    {
        height += 44;
    }
    
    return  height;
}

- (int) getRequiredWidth
{
    int width = self.view.frame.size.width;
    
    return width;
}

@end
