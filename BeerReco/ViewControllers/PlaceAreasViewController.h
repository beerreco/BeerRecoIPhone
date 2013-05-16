//
//  PlaceAreasViewController.h
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseSearchAndRefreshTableViewController.h"

@protocol PlaceSelectionDelegate <NSObject>

-(void)selectedPlace:(PlaceViewM*)placeView;

@end

@interface PlaceAreasViewController : BaseSearchAndRefreshTableViewController

@property (nonatomic) BOOL placeSelectionMode;

@property (nonatomic, weak) id<PlaceSelectionDelegate> placeSelectionDelegate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segPlaceFiltering;

- (IBAction)placeFilteringValueChanged:(id)sender;

@end
