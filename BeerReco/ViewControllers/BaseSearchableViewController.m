//
//  BaseSearchableViewController.m
//  BeerReco
//
//  Created by RLemberg on 2/26/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BaseSearchableViewController.h"

@interface BaseSearchableViewController ()

@end

@implementation BaseSearchableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Public Methods

-(void)visualSetup
{
    self.barBtbSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(btnSearchClicked:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.barBtbSearch, nil];
}

#pragma mark - Action Handlers

-(void)btnSearchClicked:(UIBarButtonItem*)sender
{
    
}

-(void)btbAddNewClicked:(UIBarButtonItem*)sender
{
    
}

@end
