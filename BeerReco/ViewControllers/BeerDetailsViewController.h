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

@interface BeerDetailsViewController : UIViewController<MBProgressHUDDelegate, UITableViewDataSource, UITableViewDelegate>

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
@property (weak, nonatomic) IBOutlet UITableView *tbBeerProperties;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroller;

@property (nonatomic, strong) UIBarButtonItem* barBtnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnEditBeerName;
@property (weak, nonatomic) IBOutlet UIButton *btnEditBeerType;
@property (weak, nonatomic) IBOutlet UIButton *btnEditBeerIcon;

- (IBAction)likeClicked:(id)sender;
- (IBAction)favoritesButtonClicked:(id)sender;

- (void)contributionEditClicked:(UIBarButtonItem *)sender;
- (IBAction)editBeerNameClicked:(UIButton*)sender;
- (IBAction)editBeerTypeClicked:(UIButton*)sender;
- (IBAction)editBeerIconClicked:(UIButton *)sender;

@end
