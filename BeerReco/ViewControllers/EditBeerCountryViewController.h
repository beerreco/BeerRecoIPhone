//
//  EditBeerCountryViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleAddEditViewController.h"
#import "BeerCategoriesViewController.h"

@interface EditBeerCountryViewController : SimpleAddEditViewController <UITableViewDataSource, UITableViewDelegate, OriginCountrySelectionDelegate>

@property (nonatomic, strong) BeerViewM* editedItem;

@property (nonatomic, strong) CountryM* selectedItem;

@property (nonatomic, weak) IBOutlet UITableView* tbSelection;
@property (weak, nonatomic) IBOutlet UIButton *btnClearSelection;

- (IBAction)clearSelectionClicked:(id)sender;

@end
