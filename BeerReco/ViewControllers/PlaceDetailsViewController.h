//
//  PlaceDetailsViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlaceViewM.h"
#import "MBProgressHUD.h"

@interface PlaceDetailsViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic, strong) PlaceViewM* placeView;

@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceArea;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlaceIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnComments;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityCommentsLoad;

@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLikeCheck;
@property (weak, nonatomic) IBOutlet UITableView *tbPlaceProperties;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroller;

@property (nonatomic, strong) UIBarButtonItem* barBtnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnEditPlaceName;
@property (weak, nonatomic) IBOutlet UIButton *btnEditPlaceArea;
@property (weak, nonatomic) IBOutlet UIButton *btnEditPlaceIcon;

- (IBAction)likeClicked:(id)sender;

- (void)contributionEditClicked:(UIBarButtonItem *)sender;
- (IBAction)editPlaceNameClicked:(UIButton*)sender;
- (IBAction)editPlaceAreaClicked:(UIButton*)sender;
- (IBAction)editPlaceIconClicked:(UIButton *)sender;

@end
