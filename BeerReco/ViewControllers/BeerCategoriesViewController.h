//
//  BeerCategoriesViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSearchAndRefreshTableViewController.h"

#import "BeerM.h"
#import "BeerTypeM.h"

@interface BeerCategoriesViewController : BaseSearchAndRefreshTableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segCategories;

- (IBAction)categorySegValueChanged:(id)sender;

@end
