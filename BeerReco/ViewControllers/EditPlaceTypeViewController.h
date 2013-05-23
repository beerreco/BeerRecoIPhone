//
//  EditPlaceTypeViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleAddEditViewController.h"
#import "PlaceAreasViewController.h"

@interface EditPlaceTypeViewController : SimpleAddEditViewController <UITableViewDataSource, UITableViewDelegate, PlaceTypeSelectionDelegate>

@property (nonatomic, strong) PlaceViewM* editedItem;

@property (nonatomic, strong) PlaceTypeM* selectedItem;

@property (nonatomic, weak) IBOutlet UITableView* tbSelection;
@property (weak, nonatomic) IBOutlet UIButton *btnClearSelection;

- (IBAction)clearSelectionClicked:(id)sender;

@end
