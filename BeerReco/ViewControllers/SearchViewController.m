//
//  SecondViewController.m
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self visualSetup];
    
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

-(void)visualSetup
{
    [self setTitle:@"Search"];
}

-(void)setup
{
}

@end
