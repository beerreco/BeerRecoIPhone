//
//  AddEditCountryViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/15/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleAddEditViewController.h"

@interface AddEditCountryViewController : SimpleAddEditViewController

@property (nonatomic, strong) CountryM* editedItem;

@end
