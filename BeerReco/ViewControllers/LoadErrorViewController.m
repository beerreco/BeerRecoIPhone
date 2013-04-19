//
//  LoadErrorViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/19/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "LoadErrorViewController.h"

@interface LoadErrorViewController ()

@end

@implementation LoadErrorViewController

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

- (void)viewDidUnload
{
    [self setBtnReload:nil];
    [super viewDidUnload];
}

#pragma mark - Action Hanlders

- (IBAction)reloadClicked:(id)sender
{
    [self.delegate reloadRequested];
}

@end
