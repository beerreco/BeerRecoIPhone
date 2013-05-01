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

@property (nonatomic, strong) MBProgressHUD* HUD;

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
    [self setLblPlaceName:nil];
    [self setLblPlaceArea:nil];
    [self setImgPlaceIcon:nil];
    [self setBtnComments:nil];
    [self setActivityCommentsLoad:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateCommentsButton];
    
    [self addLikeButton];
}

#pragma mark - Private Methods

-(void)visualSetup
{    
    [self addLikeButton];
}

-(void)setup
{
    self.lblPlaceName.text = self.placeView.place.name;
    self.lblPlaceArea.text = self.placeView.area.name;
    
    NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:self.placeView.place.placeIconUrl];
    [self.imgPlaceIcon setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"weihenstephaner_hefe_icon"]];
}

-(void)updateCommentsButton
{
    [self.btnComments setTitle:@"Comments" forState:UIControlStateNormal];
    [self.activityCommentsLoad startAnimating];
    
    NSString* fullObjectId = [[ComServices sharedComServices].placesService getFullUrlForPlaceId:self.placeView.place.id];
    
    [[FacebookHelper sharedFacebookHelper] getCommentsCountForExternalObject:fullObjectId onComplete:^(int count, NSError *error)
     {
         if (count > 0)
         {
             [self.btnComments setTitle:[NSString stringWithFormat:@"%d Comments", count] forState:UIControlStateNormal];
         }
         
         [self.activityCommentsLoad stopAnimating];
     }];
}

#pragma mark Like handling

-(void)addLikeButton
{
    if ([[GeneralDataStore sharedDataStore] hasFBUser])
    {
        [self.activityLikeCheck startAnimating];
        
        NSString* fullObjectId = [[ComServices sharedComServices].placesService getFullUrlForPlaceId:self.placeView.place.id];
        
        [[FacebookHelper sharedFacebookHelper] checkIfExternalObjectIsLiked:fullObjectId onComplete:^(BOOL liked, NSError *error)
         {
             if (liked)
             {
                 [self makeUnlikeButton];
             }
             else
             {
                 [self makeLikeButton];
             }
             
             [self.activityLikeCheck stopAnimating];
         }];
    }
    else
    {
        [self makeLikeButton];
    }
}

-(void)makeLikeButton
{
    [self.btnLike setTitle:@"Like" forState:UIControlStateNormal];
    [self.btnLike setTag:0];
}

-(void)makeUnlikeButton
{
    [self.btnLike setTitle:@"Unlike" forState:UIControlStateNormal];
    [self.btnLike setTag:1];
}

- (void)likeObject
{
    if (FBSession.activeSession.isOpen)
    {
        if (self.HUD == nil)
        {
            self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.HUD.delegate = self;
            self.HUD.dimBackground = YES;
        }
        
        NSString* fullObjectId = [[ComServices sharedComServices].placesService getFullUrlForPlaceId:self.placeView.place.id];
        
        [[FacebookHelper sharedFacebookHelper] likeExternalObject:fullObjectId onComplete:^(BOOL added, NSError *error)
         {
             if (added)
             {
                 [self makeUnlikeButton];
             }
             
             [self.HUD hide:YES];
         }];
    }
}

- (void)unlikeObject
{
    if (FBSession.activeSession.isOpen)
    {
        if (self.HUD == nil)
        {
            self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.HUD.delegate = self;
            self.HUD.dimBackground = YES;
        }
        
        NSString* fullObjectId = [[ComServices sharedComServices].placesService getFullUrlForPlaceId:self.placeView.place.id];
        
        [[FacebookHelper sharedFacebookHelper] getLikeObjectIdOnExternalObject:fullObjectId onComplete:^(NSString *likeObjectId, NSError *error)
         {
             if (![NSString isNullOrEmpty:likeObjectId])
             {
                 [[FacebookHelper sharedFacebookHelper] removeOGObject:likeObjectId onComplete:^(BOOL deleted, NSError *error)
                  {
                      if (deleted)
                      {
                          [self makeLikeButton];
                      }
                      
                      [self.HUD hide:YES];
                  }];
             }
             else
             {
                 [self.HUD hide:YES];
             }
         }];
    }
}

#pragma mark - Notifications Handlers

-(void)facebookLoggedIn:(NSNotification*)notification
{
    [self performSelector:@selector(addFavoritesButton) withObject:nil afterDelay:1];
}

-(void)facebookLoggedOut:(NSNotification*)notification
{
    [self makeLikeButton];
}

#pragma mark - Action Handlers

- (IBAction)likeClicked:(id)sender
{
    if ([[FacebookHelper sharedFacebookHelper] hasSessionWithAccessToken])
    {
        if (self.btnLike.tag == 0)
        {
            [self likeObject];
        }
        else if (self.btnLike.tag == 1)
        {
            [self unlikeObject];
        }
    }
    else
    {
        if (self.HUD == nil)
        {
            self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.HUD.delegate = self;
            self.HUD.dimBackground = YES;
        }
        
        [[FacebookHelper sharedFacebookHelper] openSession:NO onComplete:^(NSError *error)
         {
             if (error == nil)
             {
                 if (self.btnLike.tag == 0)
                 {
                     NSString* fullObjectId = [[ComServices sharedComServices].placesService getFullUrlForPlaceId:self.placeView.place.id];
                     
                     [[FacebookHelper sharedFacebookHelper] checkIfExternalObjectIsLiked:fullObjectId onComplete:^(BOOL liked, NSError *error)
                      {
                          if (liked)
                          {
                              [self makeUnlikeButton];
                              
                              [self.HUD hide:YES];
                          }
                          else
                          {
                              [self likeObject];
                          }
                      }];
                 }
                 else if (self.btnLike.tag == 1)
                 {
                     [self unlikeObject];
                 }
             }
             else
             {
                 [self.HUD hide:YES];
             }
         }];
    }
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

#pragma mark - MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	if (self.HUD == hud)
    {
        self.HUD = nil;
    }
}

@end
