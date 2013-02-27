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

@interface RecentBeersViewController : PullToRefreshViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbRecentBeers;

@end
