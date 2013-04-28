//
//  PlaceDetailsViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlaceDetailsViewController.h"

@interface PlaceDetailsViewController ()

@end

@implementation PlaceDetailsViewController

@synthesize placeView = _placeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

- (void)viewDidUnload
{
    [self setLblPlaceName:nil];
    [self setLblPlaceArea:nil];
    [self setImgPlaceIcon:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

-(void)visualSetup
{
}

-(void)setup
{
    self.lblPlaceName.text = self.placeView.place.name;
    self.lblPlaceArea.text = self.placeView.area.name;
    
    NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:self.placeView.place.placeIconUrl];
    [self.imgPlaceIcon setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"weihenstephaner_hefe_icon"]];
}

@end
