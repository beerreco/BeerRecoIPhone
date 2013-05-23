//
//  EditBreweryViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleAddEditViewController.h"
#import "BeerCategoriesViewController.h"

@interface EditBeerBreweryViewController : SimpleAddEditViewController <UITableViewDataSource, UITableViewDelegate, BrewerySelectionDelegate>

@property (nonatomic, strong) BeerViewM* editedItem;

@property (nonatomic, strong) BreweryM* selectedItem;

@property (nonatomic, weak) IBOutlet UITableView* tbSelection;
@property (weak, nonatomic) IBOutlet UIButton *btnClearSelection;

- (IBAction)clearSelectionClicked:(id)sender;

@end
