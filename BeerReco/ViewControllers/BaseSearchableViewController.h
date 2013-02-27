//
//  BaseSearchableViewController.h
//  BeerReco
//
//  Created by RLemberg on 2/26/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSearchableViewController : UIViewController

#pragma mark - Members
@property (nonatomic, strong) UIBarButtonItem* barBtbSearch;
@property (nonatomic, strong) UIBarButtonItem* barBtbAddNew;

#pragma mark - Public Methods
-(void)visualSetup;

#pragma mark - Action Handlers
-(void)btnSearchClicked:(UIBarButtonItem*)sender;
-(void)btbAddNewClicked:(UIBarButtonItem*)sender;

@end
