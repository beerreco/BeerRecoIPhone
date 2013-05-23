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

@protocol PlaceTypeSelectionDelegate <NSObject>
-(void)selectedPlaceType:(PlaceTypeM*)placeType;
@end

@protocol AreaSelectionDelegate <NSObject>
-(void)selectedArea:(AreaM*)area;
@end

@interface PlaceAreasViewController : BaseSearchAndRefreshTableViewController

@property (nonatomic) BOOL placeSelectionMode;
@property (nonatomic, weak) id<PlaceSelectionDelegate> placeSelectionDelegate;

@property (nonatomic) BOOL placeTypeSelectionMode;
@property (nonatomic, weak) id<PlaceTypeSelectionDelegate> placeTypeSelectionDelegate;

@property (nonatomic) BOOL areaSelectionMode;
@property (nonatomic, weak) id<AreaSelectionDelegate> areaSelectionDelegate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segPlaceFiltering;

- (IBAction)placeFilteringValueChanged:(id)sender;

@end
