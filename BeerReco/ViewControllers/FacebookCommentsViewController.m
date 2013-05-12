//
//  FacebookCommentsViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/28/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FacebookCommentsViewController.h"
#import "AppDelegate.h"

#define DefaultImageUrl @"https://fbstatic-a.akamaihd.net/images/devsite/attachment_blank.png"

@interface FacebookCommentsViewController ()

@end

@implementation FacebookCommentsViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoggedIn:) name:GlobalMessage_FB_LoggedIn object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoggedOut:) name:GlobalMessage_FB_LoggedOut object:nil];
    
    [self visualSetup];
    
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setFacebookCommentsView:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

-(void)visualSetup
{
}

-(void)setup
{
    
    NSString* objectId = @"";
    NSMutableDictionary* metaData = [[NSMutableDictionary alloc] init];
    if (self.beerView)
    {
        objectId = [[ComServices sharedComServices].beersService getFullUrlForBeerId:self.beerView.beer.id];
        [metaData setObject:@"beerreco:beer" forKey:@"og:type"];
        [metaData setObject:self.beerView.beer.name forKey:@"og:title"];
        [metaData setObject:objectId forKey:@"og:url"];
        
        if (![NSString isNullOrEmpty:self.beerView.beer.beerIconUrl])
        {
            [metaData setObject:[BeerRecoAPIClient getFullPathForFile:self.beerView.beer.beerIconUrl] forKey:@"og:image"];
        }
        else
        {
            [metaData setObject:DefaultImageUrl forKey:@"og:image"];
        }
        
        [metaData setObject:@"Beer Reco" forKey:@"og:site_name"];
        [metaData setObject:[NSString stringWithFormat:@"Beer Catrgory: %@", self.beerView.beerType.name] forKey:@"og:description"];
    }
    else if (self.placeView)
    {
        objectId = [[ComServices sharedComServices].placesService getFullUrlForPlaceId:self.placeView.place.id];
        
        if (![NSString isNullOrEmpty:self.placeView.place.type])
        {
            [metaData setObject:[NSString stringWithFormat:@"beerreco:%@", [self.placeView.place.type lowercaseString]] forKey:@"og:type"];
        }
        
        [metaData setObject:self.placeView.place.name forKey:@"og:title"];
        [metaData setObject:objectId forKey:@"og:url"];
        
        if (![NSString isNullOrEmpty:self.placeView.place.placeIconUrl])
        {
            [metaData setObject:[BeerRecoAPIClient getFullPathForFile:self.placeView.place.placeIconUrl] forKey:@"og:image"];
        }
        else
        {
            [metaData setObject:DefaultImageUrl forKey:@"og:image"];
        }
        
        [metaData setObject:@"Beer Reco" forKey:@"og:site_name"];
        [metaData setObject:[NSString stringWithFormat:@"Place Area: %@", self.placeView.area.name] forKey:@"og:description"];
    }
    
    self.facebookCommentsView.href = [NSURL URLWithString:objectId];
    self.facebookCommentsView.metaData = metaData;
    self.facebookCommentsView.numbeOfPosts = 10;
    
    self.facebookCommentsView.alpha = 0;
    [self.facebookCommentsView load];
}

#pragma mark - Notifications Handlers

-(void)facebookLoggedIn:(NSNotification*)notification
{
    self.facebookCommentsView.alpha = 1;
    [self.facebookCommentsView load];
}

-(void)facebookLoggedOut:(NSNotification*)notification
{
    self.facebookCommentsView.alpha = 1;
    [self.facebookCommentsView load];
}

#pragma mark FacebookCommentsViewDelegate methods

-(void)facebookCommentsView:(FacebookCommentsView *)aFacebookCommentsView didFailLoadWithError:(NSError *)error
{
}

- (void)facebookCommentsViewRequiresLogin:(FacebookCommentsView *)aFacebookCommentsView
{
    [[FacebookHelper sharedFacebookHelper] openSession:^(NSError *error)
     {
        
    }];
}

- (void)facebookCommentsViewDidRender:(FacebookCommentsView *)aFacebookCommentsView
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    self.facebookCommentsView.alpha = 1;
    [UIView commitAnimations];
}

- (void)facebookCommentsViewDidCreateComment:(FacebookCommentsView *)aFacebookCommentsView
{
    
}

- (void)FacebookCommentsViewDidDeleteComment:(FacebookCommentsView *)aFacebookCommentsView
{
    
}

#pragma mark - Action Handlers

- (IBAction)doneClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
