//
//  PlaceDetailsViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlaceViewM.h"

@interface PlaceDetailsViewController : UIViewController

@property (nonatomic, strong) PlaceViewM* placeView;

@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceArea;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlaceIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnComments;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityCommentsLoad;

@end
