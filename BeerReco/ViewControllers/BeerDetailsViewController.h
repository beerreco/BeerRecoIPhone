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

@interface BeerDetailsViewController : UIViewController<MBProgressHUDDelegate>

@property (nonatomic, strong) BeerViewM* beerView;

@property (weak, nonatomic) IBOutlet UILabel *lblBeerName;
@property (weak, nonatomic) IBOutlet UILabel *lblBeerCategory;
@property (weak, nonatomic) IBOutlet UIImageView *imgBeerIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnComments;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityCommentsLoad;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorites;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityFavoriteCheck;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLikeCheck;

- (IBAction)likeClicked:(id)sender;
- (IBAction)favoritesButtonClicked:(id)sender;

@end
