//
//  EditPlaceAreaViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleAddEditViewController.h"
#import "PlaceAreasViewController.h"

@interface EditPlaceAreaViewController : SimpleAddEditViewController <UITableViewDataSource, UITableViewDelegate, AreaSelectionDelegate>

@property (nonatomic, strong) PlaceViewM* editedItem;

@property (nonatomic, strong) AreaM* selectedItem;

@property (nonatomic, weak) IBOutlet UITableView* tbSelection;

@end
