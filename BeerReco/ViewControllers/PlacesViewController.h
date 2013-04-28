//
//  PlacesViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"
#import "MBProgressHUD.h"

#import "LoadErrorViewController.h"

#import "AreaM.h"
#import "PlaceDetailsViewController.h"

@interface PlacesViewController : PullToRefreshViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, MBProgressHUDDelegate, LoadErrorDelegate>

@property (nonatomic, strong) AreaM* parentArea;

@property (weak, nonatomic) IBOutlet UISearchBar *placesSearchBar;

- (IBAction)showSearchClicked:(id)sender;

@end
