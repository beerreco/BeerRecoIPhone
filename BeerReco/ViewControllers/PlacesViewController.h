//
//  PlacesViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSearchAndRefreshTableViewController.h"
#import "AreaM.h"
#import "PlaceDetailsViewController.h"

@interface PlacesViewController : BaseSearchAndRefreshTableViewController

@property (nonatomic, strong) AreaM* parentArea;

@end
