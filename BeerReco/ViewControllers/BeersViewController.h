//
//  BeersViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"
#import "MBProgressHUD.h"
#import "BeerDetailsViewController.h"

#import "LoadErrorViewController.h"

#import "BeerM.h"

@interface BeersViewController : PullToRefreshViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, MBProgressHUDDelegate, LoadErrorDelegate>

@property (nonatomic, strong) BeerCategoryM* parentBeerCategory;
@property (nonatomic, strong) CountryM* parentCountry;

@property (weak, nonatomic) IBOutlet UISearchBar *beersSearchBar;

- (IBAction)showSearchClicked:(id)sender;

@end
