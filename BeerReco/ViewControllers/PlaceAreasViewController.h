//
//  PlaceAreasViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullToRefreshViewController.h"
#import "MBProgressHUD.h"

#import "LoadErrorViewController.h"

@interface PlaceAreasViewController : PullToRefreshViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, MBProgressHUDDelegate, LoadErrorDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *areasSearchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segPlaceFiltering;

- (IBAction)placeFilteringValueChanged:(id)sender;

- (IBAction)showSearchClicked:(id)sender;

@end
