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
#import "EditBeerNameViewController.h"
#import "EditBeerIconViewController.h"
#import "EditBeerComponentsViewController.h"
#import "EditAlcoholPercentViewController.h"
#import "EditBeerBeerTypeViewController.h"
#import "EditBeerBreweryViewController.h"
#import "EditBeerCountryViewController.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookReceivedUser:) name:GlobalMessage_FB_ReceivedUser object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoggedOut:) name:GlobalMessage_FB_LoggedOut object:nil];
    
    [self visualSetup];
    
    [self setup];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateCommentsButton];
    
    [self addFavoritesButton];
    
    [self addLikeButton];
    
    [self showHideContributionEditButon];
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
    [self setBtnEditBeerType:nil];
    [self setBtnEditBeerIcon:nil];
    [super viewDidUnload];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (self.editing != editing)
    {
        [super setEditing:editing animated:animated];
        
        [self.tbBeerProperties setEditing:editing animated:animated];
        
        [self showBeerEditButtons:editing];
        
        if (editing)
        {
            [self.barBtnEdit setTitle:@"Done"];
            [self.barBtnEdit setStyle:UIBarButtonItemStyleDone];
            
        }
        else
        {
            [self.barBtnEdit setTitle:@"Edit"];
            [self.barBtnEdit setStyle:UIBarButtonItemStyleBordered];
        }
    }
}

#pragma mark - Private Methods

-(void)visualSetup
{
    self.navigationItem.title = self.beerView.beer.name;
    
    [self addCommentsButton];
    
    if (self.barBtnEdit == nil)
    {
        self.barBtnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(contributionEditClicked:)];
    }
    
    [self showHideContributionEditButon];
    
    [self performSelector:@selector(adjustScrollViewerContentSize) withObject:nil afterDelay:0.1];
}

-(void)setup
{
    self.lblBeerName.text = self.beerView.beer.name;
    self.lblBeerCategory.text = self.beerView.beerType.name;
    
    NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:self.beerView.beer.beerIconUrl];
    [self.imgBeerIcon setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"beer_icon_default"]];
}

-(void)adjustScrollViewerContentSize
{
    self.contentScroller.contentSize =
    CGSizeMake(320, self.tbBeerProperties.frame.size.height + self.tbBeerProperties.frame.origin.y);
}

-(void)addCommentsButton
{
    [self.btnComments setBackgroundImage:[UIImage imageNamed:@"comments_button_bg"] forState:UIControlStateNormal];
    self.btnComments.layer.cornerRadius = 10;
    self.btnComments.clipsToBounds = YES;
    self.btnComments.layer.borderWidth = 1;
    self.btnComments.layer.borderColor = [[UIColor blackColor] CGColor];
}

-(void)updateCommentsButton
{
    [self.btnComments setTitle:@"Show Comments" forState:UIControlStateNormal];
    [self.btnComments setEnabled:NO];
    [self.activityCommentsLoad startAnimating];
    
    NSString* fullObjectId = [[ComServices sharedComServices].beersService getFullUrlForBeerId:self.beerView.beer.id];
    
    [[FacebookHelper sharedFacebookHelper] getCommentsCountForExternalObject:fullObjectId onComplete:^(int count, NSError *error)
     {
         if (count > 0)
         {
             [self.btnComments setTitle:[NSString stringWithFormat:@"Show %d Comments", count] forState:UIControlStateNormal];
         }
         
         [self.activityCommentsLoad stopAnimating];
             [self.btnComments setEnabled:YES];
     }];
}

-(void)showHideContributionEditButon
{
    if ([GeneralDataStore sharedDataStore].contributionAllowed)
    {
        [self.navigationItem setRightBarButtonItem:self.barBtnEdit animated:YES];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
        
        if (self.editing)
        {
            [self setEditing:NO animated:YES];
        }
    }
}

-(void)showBeerEditButtons:(BOOL)show
{
    [self.btnEditBeerName setHidden:!show];
    [self.btnEditBeerType setHidden:!show];
    [self.btnEditBeerIcon setHidden:!show];
}

-(UIButton*)makeDetailDisclosureButton
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [button setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
    
    [button addTarget: self
               action: @selector(accessoryButtonTapped:withEvent:)
     forControlEvents: UIControlEventTouchUpInside];
    
    return button;
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
    [self.btnLike setImage:[UIImage imageNamed:@"like_beer"] forState:UIControlStateNormal];
    [self.btnLike setTag:0];
}

-(void)makeUnlikeButton
{
    [self.btnLike setImage:[UIImage imageNamed:@"unlike_beer"] forState:UIControlStateNormal];
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
    [self.btnFavorites setImage:[UIImage imageNamed:@"add_to_fav"] forState:UIControlStateNormal];
    [self.btnFavorites setTag:0];
}

-(void)makeRemoveFavoritesButton
{
    [self.btnFavorites setImage:[UIImage imageNamed:@"remove_from_fav"] forState:UIControlStateNormal];
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

-(void)facebookReceivedUser:(NSNotification*)notification
{
    [self addFavoritesButton];
    
    [self addLikeButton];
    
    [self showHideContributionEditButon];
}

-(void)facebookLoggedOut:(NSNotification*)notification
{
    [self makeAddFavoritesButton];
    
    [self makeLikeButton];
    
    [self showHideContributionEditButon];
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

- (void)contributionEditClicked:(UIBarButtonItem *)sender
{
    if (self.editing)
	{
		[self setEditing:NO animated:YES];
	}
	else
	{
		[self setEditing:YES animated:YES];
	}
}

- (IBAction)editBeerNameClicked:(UIButton*)sender
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    EditBeerNameViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditBeerNameViewController"];
    
    vc.editedItem = self.beerView.beer;
    
    [navController setViewControllers:@[vc]];
    
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)editBeerTypeClicked:(UIButton*)sender
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    EditBeerBeerTypeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditBeerTypeViewController"];
    
    vc.editedItem = self.beerView;
    
    [navController setViewControllers:@[vc]];
    
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)editBeerIconClicked:(UIButton *)sender
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    EditBeerIconViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditBeerIconViewController"];
    
    vc.editedItem = self.beerView.beer;
    
    [navController setViewControllers:@[vc]];
    
    [self presentModalViewController:navController animated:YES];
}

- (void)accessoryButtonTapped:(UIControl*)button withEvent:(UIEvent*)event
{
    NSIndexPath * indexPath = [self.tbBeerProperties indexPathForRowAtPoint:[[[event touchesForView: button] anyObject] locationInView: self.tbBeerProperties]];
    if ( indexPath == nil )
        return;
    
    [self.tbBeerProperties.delegate tableView: self.tbBeerProperties accessoryButtonTappedForRowWithIndexPath: indexPath];
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
    
    if (cell.backgroundView == nil)
    {
        UIImageView* backgroud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg"]];
        backgroud.alpha = 0.85;
        backgroud.layer.cornerRadius = 15;
        backgroud.clipsToBounds = YES;
        
        backgroud.layer.borderWidth = 0.5;
        backgroud.layer.borderColor = [[UIColor grayColor] CGColor];
        
        cell.backgroundView = backgroud;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setEditingAccessoryView:[self makeDetailDisclosureButton]];
        
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
            cell.textLabel.text = [NSString stringWithFormat:@"Alcohol Percentage: %@", self.beerView.beer.alchoholPrecent > 0 ?[NSString stringWithFormat:@"%.1f", self.beerView.beer.alchoholPrecent] : @"N/A"];
        }
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    if (indexPath.row == 0)
    {
        // Origin Country
        EditBeerCountryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditBeerCountryViewController"];
        
        vc.editedItem = self.beerView;
        
        [navController setViewControllers:@[vc]];
    }
    else if (indexPath.row == 1)
    {
        // Brewery
        EditBeerBreweryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditBeerBreweryViewController"];
        
        vc.editedItem = self.beerView;
        
        [navController setViewControllers:@[vc]];
    }
    else if (indexPath.row == 2)
    {
        // Components
        EditBeerComponentsViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditBeerComponentsViewController"];
        
        vc.editedItem = self.beerView.beer;
        
        [navController setViewControllers:@[vc]];
    }
    else if (indexPath.row == 3)
    {
        // Alcohol perecent
        EditAlcoholPercentViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditAlcoholPercentViewController"];
        
        vc.editedItem = self.beerView.beer;
        
        [navController setViewControllers:@[vc]];
    }
    
    [self presentModalViewController:navController animated:YES];
}

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
