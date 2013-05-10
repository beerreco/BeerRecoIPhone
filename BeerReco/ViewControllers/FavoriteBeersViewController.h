//
//  FirstViewController.h
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSearchAndRefreshTableViewController.h"
#import "BeerDetailsViewController.h"

#import "BeerM.h"

@interface FavoriteBeersViewController : BaseSearchAndRefreshTableViewController <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *SegFavoriteListType;

- (IBAction)favoriteListTypeChanged:(UISegmentedControl *)sender forEvent:(UIEvent *)event;

@end
