//
//  FirstViewController.h
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSearchableViewController.h"
#import "PullToRefreshViewController.h"
#import "MBProgressHUD.h"

#import <FacebookSDK/FacebookSDK.h>

#import "BeerM.h"

@interface FavoriteBeersViewController : PullToRefreshViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, FBLoginViewDelegate, MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *SegFavoriteListType;
@property (weak, nonatomic) IBOutlet UISearchBar *favoritesSearchBar;

- (IBAction)showSearchClicked:(UIBarButtonItem *)sender;
- (IBAction)favoriteListTypeChanged:(UISegmentedControl *)sender forEvent:(UIEvent *)event;

@end
