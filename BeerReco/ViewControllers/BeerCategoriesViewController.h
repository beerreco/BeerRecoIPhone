//
//  BeerCategoriesViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"
#import "MBProgressHUD.h"

#import "LoadErrorViewController.h"

#import "BeerM.h"
#import "BeerCategoryM.h"

@interface BeerCategoriesViewController : PullToRefreshViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, MBProgressHUDDelegate, LoadErrorDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *categoriesSearchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCategories;

- (IBAction)categorySegValueChanged:(id)sender;

- (IBAction)showSearchClicked:(id)sender;

@end
