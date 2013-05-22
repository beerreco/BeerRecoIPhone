//
//  PlaceDetailsViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PlaceDetailsViewController.h"
#import "FacebookCommentsViewController.h"
#import "BeersInPlaceViewController.h"
#import "EditPlaceNameViewController.h"
#import "EditPlaceIconViewController.h"
#import "EditPlaceAddressViewController.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookReceivedUser:) name:GlobalMessage_FB_ReceivedUser object:nil];
    
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
    [self setTbPlaceProperties:nil];
    [self setContentScroller:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateCommentsButton];
    
    [self addLikeButton];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (self.editing != editing)
    {
        [super setEditing:editing animated:animated];
        
        [self.tbPlaceProperties setEditing:editing animated:animated];
        
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
    self.navigationItem.title = self.placeView.place.name;
    
    [self addCommentsButton];
    
    if (self.barBtnEdit == nil)
    {
        self.barBtnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(contributionEditClicked:)];
    }
    
    [self showHideContributionEditButon];
    
    [self addLikeButton];
    
    [self performSelector:@selector(adjustScrollViewerContentSize) withObject:nil afterDelay:0.1];
}

-(void)setup
{
    self.lblPlaceName.text = self.placeView.place.name;
    self.lblPlaceArea.text = self.placeView.area.name;
    
    NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:self.placeView.place.placeIconUrl];
    [self.imgPlaceIcon setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"place_icon_default"]];
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
    [self.activityCommentsLoad startAnimating];
    [self.btnComments setEnabled:NO];
    
    NSString* fullObjectId = [[ComServices sharedComServices].placesService getFullUrlForPlaceId:self.placeView.place.id];
    
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

-(void)adjustScrollViewerContentSize
{
    self.contentScroller.contentSize = CGSizeMake(320, self.tbPlaceProperties.frame.size.height + self.tbPlaceProperties.frame.origin.y);
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
    [self.btnEditPlaceName setHidden:!show];
    [self.btnEditPlaceArea setHidden:!show];
    [self.btnEditPlaceIcon setHidden:!show];
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

-(void)facebookReceivedUser:(NSNotification*)notification
{
    [self addLikeButton];
    
    [self showHideContributionEditButon];
}

-(void)facebookLoggedOut:(NSNotification*)notification
{
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

- (IBAction)editPlaceNameClicked:(UIButton*)sender
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    EditPlaceNameViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPlaceNameViewController"];
    
    vc.editedItem = self.placeView.place;
    
    [navController setViewControllers:@[vc]];
    
    [self presentModalViewController:navController animated:YES];
}

- (IBAction)editPlaceAreaClicked:(UIButton*)sender
{
    
}

- (IBAction)editPlaceIconClicked:(UIButton *)sender
{
    UINavigationController* navController = [[UINavigationController alloc] init];
    
    EditPlaceIconViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPlaceIconViewController"];
    
    vc.editedItem = self.placeView.place;
    
    [navController setViewControllers:@[vc]];
    
    [self presentModalViewController:navController animated:YES];
}

- (void)accessoryButtonTapped:(UIControl*)button withEvent:(UIEvent*)event
{
    NSIndexPath * indexPath = [self.tbPlaceProperties indexPathForRowAtPoint:[[[event touchesForView: button] anyObject] locationInView: self.tbPlaceProperties]];
    if ( indexPath == nil )
        return;
    
    [self.tbPlaceProperties.delegate tableView: self.tbPlaceProperties accessoryButtonTappedForRowWithIndexPath: indexPath];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CommentsSegue"])
    {
        FacebookCommentsViewController *facebookCommentsViewController = [segue destinationViewController];
        
        facebookCommentsViewController.placeView = self.placeView;
        
        [facebookCommentsViewController setTitle:self.placeView.place.name];
    }
    
    if ([segue.identifier isEqualToString:@"BeersInPlaceSegue"])
    {
        BeersInPlaceViewController *beersInPlaceViewController = [segue destinationViewController];
        
        beersInPlaceViewController.placeView = self.placeView;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 1;
    }
    else if (section == 0)
    {
        return 2;
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
        backgroud.layer.cornerRadius = 10;
        backgroud.clipsToBounds = YES;
        
        backgroud.layer.borderWidth = 0.5;
        backgroud.layer.borderColor = [[UIColor grayColor] CGColor];
        
        cell.backgroundView = backgroud;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setEditingAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    if (indexPath.section == 0)
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setEditingAccessoryView:[self makeDetailDisclosureButton]];
        
        if (indexPath.row == 0)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Type: %@", self.placeView.placeType != nil ? self.placeView.placeType.name : @""];
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Address: %@", self.placeView.place.address];
        }
    }
    else if (indexPath.section == 1)
    {        
        cell.textLabel.text = @"Beers and Prices";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if  (section == 0)
    {
        return @"Place Details";
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
        // Place Type
    }
    else if (indexPath.row == 1)
    {
        // Address
        EditPlaceAddressViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditPlaceAddressViewController"];
        
        vc.editedItem = self.placeView.place;
        
        [navController setViewControllers:@[vc]];
    }
    
    [self presentModalViewController:navController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self performSegueWithIdentifier:@"BeersInPlaceSegue" sender:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
