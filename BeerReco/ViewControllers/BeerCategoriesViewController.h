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

@protocol BeerSelectionDelegate <NSObject>

-(void)selectedBeer:(BeerViewM*)beerView;

@end

@interface BeerCategoriesViewController : BaseSearchAndRefreshTableViewController

@property (nonatomic) BOOL beerSelectionMode;

@property (nonatomic, weak) id<BeerSelectionDelegate> beerSelectionDelegate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segCategories;

- (IBAction)categorySegValueChanged:(id)sender;

@end
