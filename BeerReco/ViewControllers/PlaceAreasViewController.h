//
//  PlaceAreasViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseSearchAndRefreshTableViewController.h"

@interface PlaceAreasViewController : BaseSearchAndRefreshTableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segPlaceFiltering;

- (IBAction)placeFilteringValueChanged:(id)sender;

@end
