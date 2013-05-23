//
//  EditBeerTypeViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/22/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleAddEditViewController.h"
#import "BeerCategoriesViewController.h"

@interface EditBeerBeerTypeViewController : SimpleAddEditViewController <UITableViewDataSource, UITableViewDelegate, BeerTypeSelectionDelegate>

@property (nonatomic, strong) BeerViewM* editedItem;

@property (nonatomic, strong) BeerTypeM* selectedItem;

@property (nonatomic, weak) IBOutlet UITableView* tbSelection;
@property (weak, nonatomic) IBOutlet UIButton *btnClearSelection;

- (IBAction)clearSelectionClicked:(id)sender;

@end
