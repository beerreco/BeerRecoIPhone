//
//  PlaceDetailsViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlaceDetailsViewController.h"
#import "FacebookCommentsViewController.h"

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
    [self setBtnComments:nil];
    [self setActivityCommentsLoad:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.btnComments setTitle:@"Comments" forState:UIControlStateNormal];
    [self.activityCommentsLoad startAnimating];
    
    NSString* fullObjectId = [[ComServices sharedComServices].placesService getFullUrlForPlaceId:self.placeView.place.id];
    
    [[ComServices sharedComServices].commentsService getCommentsCountForObject:fullObjectId onComplete:^(int count, NSError *error)
     {
         if (count > 0)
         {
             [self.btnComments setTitle:[NSString stringWithFormat:@"%d Comments", count] forState:UIControlStateNormal];
         }
         
         [self.activityCommentsLoad stopAnimating];
     }];
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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CommentsSegue"])
    {
        FacebookCommentsViewController *facebookCommentsViewController = [segue destinationViewController];
        
        NSString* fullObjectId = [[ComServices sharedComServices].placesService getFullUrlForPlaceId:self.placeView.place.id];
        
        facebookCommentsViewController.objectId = fullObjectId;
        
        [facebookCommentsViewController setTitle:self.placeView.place.name];
    }
}

@end
