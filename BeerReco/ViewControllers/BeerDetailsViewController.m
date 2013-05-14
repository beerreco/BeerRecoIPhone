//
//  BeerDetailsViewController.m
//  BeerReco
//
//  Created by RLemberg on 2/26/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerDetailsViewController.h"
#import "FacebookCommentsViewController.h"
#import "BeerInPlacesViewController.h"
#import "BeersViewController.h"

@interface BeerDetailsViewController ()

@property (nonatomic, strong) MBProgressHUD* HUD;

@end

@implementation BeerDetailsViewController

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
    [self setBtnFavorites:nil];
    [self setBtnLike:nil];
    [self setActivityFavoriteCheck:nil];
    [self setActivityLikeCheck:nil];
    [self setTbBeerProperties:nil];
    [self setContentScroller:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateCommentsButton];
    
    [self addFavoritesButton];
    
    [self addLikeButton];
}

#pragma mark - Private Methods

-(void)visualSetup
{
    self.navigationItem.title = self.beerView.beer.name;
    
    [self performSelector:@selector(adjustScrollViewerContentSize) withObject:nil afterDelay:0.1];
}

-(void)setup
{
    self.lblBeerName.text = self.beerView.beer.name;
    self.lblBeerCategory.text = self.beerView.beerType.name;
    
    NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:self.beerView.beer.beerIconUrl];
    [self.imgBeerIcon setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"weihenstephaner_hefe_icon"]];
}

-(void)adjustScrollViewerContentSize
{
    self.contentScroller.contentSize = CGSizeMake(320, self.tbBeerProperties.frame.size.height + self.tbBeerProperties.frame.origin.y);
}

-(void)updateCommentsButton
{
    [self.btnComments setTitle:@"Comments" forState:UIControlStateNormal];
    [self.btnComments setEnabled:NO];
    [self.activityCommentsLoad startAnimating];
    
    NSString* fullObjectId = [[ComServices sharedComServices].beersService getFullUrlForBeerId:self.beerView.beer.id];
    
    [[FacebookHelper sharedFacebookHelper] getCommentsCountForExternalObject:fullObjectId onComplete:^(int count, NSError *error)
     {
         if (count > 0)
         {
             [self.btnComments setTitle:[NSString stringWithFormat:@"%d Comments", count] forState:UIControlStateNormal];
         }
         
         [self.activityCommentsLoad stopAnimating];
             [self.btnComments setEnabled:YES];
     }];
}

#pragma mark Like handling

-(void)addLikeButton
{
    if ([[GeneralDataStore sharedDataStore] hasFBUser])
    {
        [self.activityLikeCheck startAnimating];
        [self.btnLike setEnabled:NO];
        
        NSString* fullObjectId = [[ComServices sharedComServices].beersService getFullUrlForBeerId:self.beerView.beer.id];
        
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
             [self.btnLike setEnabled:YES];
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
        
        NSString* fullObjectId = [[ComServices sharedComServices].beersService getFullUrlForBeerId:self.beerView.beer.id];
        
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
        
        NSString* fullObjectId = [[ComServices sharedComServices].beersService getFullUrlForBeerId:self.beerView.beer.id];
        
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

#pragma mark Favorites handling

-(void)addFavoritesButton
{
    if ([[GeneralDataStore sharedDataStore] hasFBUser])
    {
        [self.activityFavoriteCheck startAnimating];
        [self.btnFavorites setEnabled:NO];
        
        [[ComServices sharedComServices].favoriteBeersService isBeerInFavorites:self.beerView.beer.id onComplete:^(BOOL inFavorites, NSError *error)
        {
            if (error == nil)
            {
                if (inFavorites)
                {
                    [self makeRemoveFavoritesButton];
                }
                else
                {
                    [self makeAddFavoritesButton];
                }
            }
            
            [self.activityFavoriteCheck stopAnimating];
            [self.btnFavorites setEnabled:YES];
        }];
    }
    else
    {
        [self makeAddFavoritesButton];
    }
}

-(void)makeAddFavoritesButton
{
    [self.btnFavorites setTitle:@"Add Fav" forState:UIControlStateNormal];
    [self.btnFavorites setTag:0];
}

-(void)makeRemoveFavoritesButton
{
    [self.btnFavorites setTitle:@"Rem Fav" forState:UIControlStateNormal];
    [self.btnFavorites setTag:1];
}

- (void)addToFavorites
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
             [self makeRemoveFavoritesButton];
         }
         
         [self.HUD hide:YES];
     }];
}

- (void)removeFromFavorites
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
             [self makeAddFavoritesButton];
         }
         
         [self.HUD hide:YES];
     }];
}

#pragma mark - Notifications Handlers

-(void)facebookLoggedIn:(NSNotification*)notification
{
    [self performSelector:@selector(addFavoritesButton) withObject:nil afterDelay:1];
}

-(void)facebookLoggedOut:(NSNotification*)notification
{
    [self makeAddFavoritesButton];
    
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
                     NSString* fullObjectId = [[ComServices sharedComServices].beersService getFullUrlForBeerId:self.beerView.beer.id];
                     
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

- (IBAction)favoritesButtonClicked:(id)sender
{
    if ([[GeneralDataStore sharedDataStore] hasFBUser])
    {
        if (self.btnFavorites.tag == 0)
        {
            [self addToFavorites];
        }
        else if (self.btnFavorites.tag == 1)
        {
            [self removeFromFavorites];
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
        
        [[FacebookHelper sharedFacebookHelper] openSession:^(NSError *error)
         {
             if (error == nil)
             {
                 [[ComServices sharedComServices].favoriteBeersService isBeerInFavorites:self.beerView.beer.id onComplete:^(BOOL inFavorites, NSError *error)
                  {
                      if (error == nil)
                      {
                          if (self.btnFavorites.tag == 0)
                          {
                              if (inFavorites)
                              {
                                  [self makeRemoveFavoritesButton];
                                  [self.HUD hide:YES];
                              }
                              else
                              {
                                  [self addToFavorites];
                              }
                          }
                          else if (self.btnFavorites.tag == 1)
                          {
                              if (inFavorites)
                              {
                                  [self removeFromFavorites];
                              }
                              else
                              {
                                  [self makeAddFavoritesButton];
                                  [self.HUD hide:YES];
                              }
                          }
                      }
                      else
                      {
                          [self.HUD hide:YES];
                      }
                  }];
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
        
        facebookCommentsViewController.beerView = self.beerView;
        
        [facebookCommentsViewController setTitle:self.beerView.beer.name];
    }
    
    if ([segue.identifier isEqualToString:@"PlacesOfBeerSegue"])
    {
        BeerInPlacesViewController *beerInPlacesViewController = [segue destinationViewController];
        
        beerInPlacesViewController.beerView = self.beerView;
    }
    
    if ([segue.identifier isEqualToString:@"SimilarBeersSegue"])
    {
        BeersViewController *beersViewController = [segue destinationViewController];
        
        beersViewController.beerView = self.beerView;
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 || section == 2)
    {
        return 1;
    }
    else if (section == 0)
    {
        return 4;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    if (indexPath.section == 1)
    {
        cell.textLabel.text = @"Places and Prices";
    }
    else if (indexPath.section == 2)
    {
        cell.textLabel.text = @"Similar Beers";
    }
    else if (indexPath.section == 0)
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.row == 0)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Origin Country: %@", self.beerView.country != nil ? self.beerView.country.name : @""];
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Brewery: %@", self.beerView.brewery != nil ? self.beerView.brewery.name : @""];
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Components: %@", self.beerView.beer.madeOf];
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Alcohol Percentage: %@", self.beerView.beer.alchoholPrecent > 0 ?[NSString stringWithFormat:@"%.0f", self.beerView.beer.alchoholPrecent] : @"N/A"];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editing ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Beer Details";
    }
    
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self performSegueWithIdentifier:@"PlacesOfBeerSegue" sender:nil];
    }
    else if (indexPath.section == 2)
    {
        [self performSegueWithIdentifier:@"SimilarBeersSegue" sender:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
