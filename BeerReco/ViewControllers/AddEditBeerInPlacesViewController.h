//
//  AddEditBeerInPlacesViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/16/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleAddEditViewController.h"
#import "PlaceAreasViewController.h"

@interface AddEditBeerInPlacesViewController : SimpleAddEditViewController <UITableViewDataSource, UITableViewDelegate, PlaceSelectionDelegate>

@property (nonatomic, strong) BeerInPlaceViewM* editedItem;

@property (nonatomic, strong) BeerViewM* beerView;

@property (nonatomic, strong) PlaceViewM* placeView;

@property (weak, nonatomic) IBOutlet UILabel *lblBoxLabel;
@property (nonatomic, weak) IBOutlet UITableView* tbSelection;

@end
