//
//  BeerDetailsViewController.h
//  BeerReco
//
//  Created by RLemberg on 2/26/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"
#import "FacebookCommentsView.h"

@interface BeerDetailsViewController : UIViewController<MBProgressHUDDelegate, FacebookCommentsViewDelegate>

@property (nonatomic, strong) BeerViewM* beerView;

@property (weak, nonatomic) IBOutlet UILabel *lblBeerName;
@property (weak, nonatomic) IBOutlet UILabel *lblBeerCategory;
@property (weak, nonatomic) IBOutlet UIImageView *imgBeerIcon;
@property (weak, nonatomic) IBOutlet FacebookCommentsView *fbCommentsView;
@property (weak, nonatomic) IBOutlet UIButton *btnComments;
- (IBAction)showCommentsClicked:(id)sender;

@end
