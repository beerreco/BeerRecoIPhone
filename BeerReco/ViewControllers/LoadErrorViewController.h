//
//  LoadErrorViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/19/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadErrorDelegate <NSObject>

-(void)reloadRequested;

@end

@interface LoadErrorViewController : UIViewController

@property (nonatomic, weak) id<LoadErrorDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnReload;

- (IBAction)reloadClicked:(id)sender;

@end
