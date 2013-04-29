//
//  BeerDetailsViewController.m
//  BeerReco
//
//  Created by RLemberg on 2/26/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerDetailsViewController.h"
#import "FacebookCommentsViewController.h"

@interface BeerDetailsViewController ()

@property (nonatomic, strong) UIBarButtonItem* btnAddToFavlorites;
@property (nonatomic, strong) UIBarButtonItem* btnRemoveFromFavlorites;
@property (nonatomic, strong) MBProgressHUD* HUD;

@end

@implementation BeerDetailsViewController

@synthesize btnAddToFavlorites = _btnAddToFavlorites;

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
    [self setLblBeerName:nil];
    [self setLblBeerCategory:nil];
    [self setImgBeerIcon:nil];
    [self setBtnComments:nil];
    [self setActivityCommentsLoad:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.btnComments setTitle:@"Comments" forState:UIControlStateNormal];
    [self.activityCommentsLoad startAnimating];
    
    NSString* fullObjectId = [[ComServices sharedComServices].beersService getFullUrlForBeerId:self.beerView.beer.id];
    
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
    if  (self.btnAddToFavlorites == nil)
    {
        self.btnAddToFavlorites = [[UIBarButtonItem alloc] initWithTitle:@"Add to Favorites" style:UIBarButtonItemStyleBordered target:self action:@selector(addToFavoritesClicked:)];
    }
    
    if  (self.btnRemoveFromFavlorites == nil)
    {
        self.btnRemoveFromFavlorites = [[UIBarButtonItem alloc] initWithTitle:@"Remove from Favorites" style:UIBarButtonItemStyleBordered target:self action:@selector(removeFromFavoritesClicked:)];
    }
    
    [self addFavoritesButton];
}

-(void)setup
{
    self.lblBeerName.text = self.beerView.beer.name;
    self.lblBeerCategory.text = self.beerView.beerCategory.name;
    
    NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:self.beerView.beer.beerIconUrl];
    [self.imgBeerIcon setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"weihenstephaner_hefe_icon"]];
}

-(void)addFavoritesButton
{
    if (FBSession.activeSession.isOpen)
    {
        [[ComServices sharedComServices].favoriteBeersService isBeerInFavorites:self.beerView.beer.id onComplete:^(BOOL inFavorites, NSError *error)
        {
            if (error == nil)
            {
                if (inFavorites)
                {
                    self.navigationItem.rightBarButtonItem = self.btnRemoveFromFavlorites;
                }
                else
                {
                    self.navigationItem.rightBarButtonItem = self.btnAddToFavlorites;
                }
            }
        }];
    }
}

-(void)removeFavoritesButton
{
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Notifications Handlers

-(void)facebookLoggedIn:(NSNotification*)notification
{
    [self performSelector:@selector(addFavoritesButton) withObject:nil afterDelay:1];
}

-(void)facebookLoggedOut:(NSNotification*)notification
{
    [self removeFavoritesButton];
}

#pragma mark - Action Handlers

- (void)addToFavoritesClicked:(id)sender
{
    if (self.HUD == nil)
    {
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.dimBackground = YES;
    }
    
    [[ComServices sharedComServices].favoriteBeersService addBeerToFavorites:self.beerView.beer.id onComplete:^(NSError *error)
     {
         if (error == nil)
         {
             self.navigationItem.rightBarButtonItem = self.btnRemoveFromFavlorites;
         }
         
         [self.HUD hide:YES];         
     }];
}

- (void)removeFromFavoritesClicked:(id)sender
{
    if (self.HUD == nil)
    {
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.dimBackground = YES;
    }
    
    [[ComServices sharedComServices].favoriteBeersService removeBeerFromFavorites:self.beerView.beer.id onComplete:^(NSError *error)
     {
         if (error == nil)
         {
             self.navigationItem.rightBarButtonItem = self.btnAddToFavlorites;
         }
         
         [self.HUD hide:YES];
     }];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CommentsSegue"])
    {
        FacebookCommentsViewController *facebookCommentsViewController = [segue destinationViewController];
        
        NSString* fullObjectId = [[ComServices sharedComServices].beersService getFullUrlForBeerId:self.beerView.beer.id];
        
        facebookCommentsViewController.objectId = fullObjectId;
        
        [facebookCommentsViewController setTitle:self.beerView.beer.name];
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
