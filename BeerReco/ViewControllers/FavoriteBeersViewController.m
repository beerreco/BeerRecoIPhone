//
//  FirstViewController.m
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FavoriteBeersViewController.h"

@interface FavoriteBeersViewController ()

@property (strong, nonatomic) FBLoginView *fbLoginView;
@property (strong, nonatomic) UIBarButtonItem *btnEditFaforites;

@end

@implementation FavoriteBeersViewController

@synthesize fbLoginView = _fbLoginView;
@synthesize btnEditFaforites = _btnEditFaforites;
@synthesize SegFavoriteListType = _SegFavoriteListType;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDid
{
    [self visualSetup];
    
    [self setup];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Private Methods

-(void)visualSetup
{
    self.navigationItem.title = @"Favorites";
    
    if (self.btnEditFaforites == nil)
    {
        self.btnEditFaforites = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPrivateFavoritesTable:)];
    }
}

-(void)setup
{
}

-(void)removeFromFavorites:(BeerViewM*)beerView onComplete:(void (^)(NSError *error))onComplete
{
    if (self.HUD == nil)
    {
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.dimBackground = YES;
    }    
    
    [[ComServices sharedComServices].favoriteBeersService removeBeerFromFavorites:beerView.beer.id onComplete:^(NSError *error)
     {
         if (error == nil)
         {
             [self.itemsArray removeObject:beerView];
             [self.filteredItemArray removeObject:beerView];
         }
         
         [self.HUD hide:YES];
         
         if (onComplete)
         {
             onComplete(error);
         }
     }];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self setEditing:editing animated:animated reload:YES];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated reload:(BOOL)reload
{
    if (self.editing != editing)
    {
        [super setEditing:editing animated:animated];
        
        [self.tableView setEditing:editing animated:YES];
        
        if (reload)
        {
            [self.tableView reloadData];
        }
        
        if (editing)
        {
            [self.btnEditFaforites setTitle:@"Done"];
            [self.btnEditFaforites setStyle:UIBarButtonItemStyleDone];
            
        }
        else
        {
            [self.btnEditFaforites setTitle:@"Edit"];
            [self.btnEditFaforites setStyle:UIBarButtonItemStylePlain];
        }
    }
}

#pragma mark - BaseSearchAndRefreshTableViewController

-(void)loadCurrentData
{
    if (self.SegFavoriteListType.selectedSegmentIndex == 0)
    {
        [self.navigationItem setLeftBarButtonItem:nil];
        
        if (self.editing)
        {
            [self setEditing:NO animated:NO reload:NO];
        }
        
        [[ComServices sharedComServices].favoriteBeersService getPublicFavoriteBeers:^(NSMutableArray *beers, NSError *error)
         {
             if (error == nil && beers != nil)
             {
                 [self dataLoaded:beers];
             }
             else
             {
                 [self showErrorView];
             }
         }];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:self.btnEditFaforites];
        
        [[ComServices sharedComServices].favoriteBeersService getFavoriteBeersForUser:^(NSMutableArray *beers, NSError *error)
         {
             if (error == nil && beers != nil)
             {
                 [self dataLoaded:beers];
             }
             else
             {
                 [self showErrorView];
             }
         }];
    }
}

-(NSString*)getSortingKeyPath
{
    return @"beer.name";
}

-(NSString*)getSearchablePropertyName
{
    return @"beer.name";
}

-(NSString*)getCellIdentifier
{
    return [super getCellIdentifier];
}

-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    [cell.detailTextLabel setText:@""];
    [cell.imageView setImage:nil];
    
    if ([object isKindOfClass:([BeerViewM class])])
    {
        BeerViewM *beerView = object;
        
        // Configure the cell
        [cell.textLabel setText:beerView.beer.name];
        
        NSString* details = @"";
        
        if (beerView.beerType)
        {
            details = [details stringByAppendingFormat:@"Type: %@", beerView.beerType.name];
        }
        
        if (beerView.country)
        {
            if (![NSString isNullOrEmpty:details])
            {
                details = [details stringByAppendingString:@" - "];
            }
            
            details = [details stringByAppendingFormat:@"Origin Country: %@", beerView.country.name];
        }
        
        if (beerView.brewery && (!beerView.country || !beerView.beerType))
        {
            if (![NSString isNullOrEmpty:details])
            {
                details = [details stringByAppendingString:@" - "];
            }
            
            details = [details stringByAppendingFormat:@"Brewery: %@", beerView.brewery.name];
        }
        
        [cell.detailTextLabel setText:details];
        
        NSString* imageUrl = [BeerRecoAPIClient getFullPathForFile:beerView.beer.beerIconUrl];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"beer_icon_default"]];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
}

-(void)tableItemSelected:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"BeerDetailsSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object
{
    if ([segue.identifier isEqualToString:@"BeerDetailsSegue"])
    {
        BeerDetailsViewController *beerDetailsViewController = [segue destinationViewController];
        
        if ([object isKindOfClass:([BeerViewM class])])
        {
            BeerViewM* beerViewM = object;
            beerDetailsViewController.beerView = beerViewM;
            [beerDetailsViewController setTitle:beerViewM.beer.name];
        }
    }
}

#pragma mark - Action Handlers

- (IBAction)favoriteListTypeChanged:(UISegmentedControl *)sender forEvent:(UIEvent *)event
{
    if (self.loadErrorViewController)
    {
        [self.loadErrorViewController removeFloatingViewControllerFromParent:^(BOOL finished)
         {
             [self setLoadErrorViewController:nil];
             
             [self favoriteListTypeChanged:self.SegFavoriteListType forEvent:nil];
         }];
    }
    else
    {
        if (self.fbLoginView == nil)
        {
            // Create Login View so that the app will be granted "status_update" permission.
            self.fbLoginView = [[FBLoginView alloc] init];
            [self.fbLoginView setPublishPermissions:[[FacebookHelper sharedFacebookHelper] getPublishPermissions]];
            [self.fbLoginView setDefaultAudience:FBSessionDefaultAudienceEveryone];
            
            self.fbLoginView.frame =  CGRectMake(self.view.center.x - (self.fbLoginView.frame.size.width / 2), self.view.center.y - (self.fbLoginView.frame.size.height / 2), self.fbLoginView.frame.size.width, self.fbLoginView.frame.size.height);
            
            self.fbLoginView.delegate = self;
            
            [self.view addSubview:self.fbLoginView];
            
            [self.fbLoginView sizeToFit];
        }
        else
        {
            if (self.SegFavoriteListType.selectedSegmentIndex == 1 && !FBSession.activeSession.isOpen)
            {
                [self.tableView setHidden:YES];
                [self.fbLoginView setHidden:NO];
            }
            else
            {
                [self.tableView setHidden:NO];
                [self.fbLoginView setHidden:YES];
                
                [self loadData];
            }
        }
    }
}

-(void)editPrivateFavoritesTable:(id)sender
{
    if (self.loadErrorViewController != nil)
    {
        return;
    }
    
	if (self.editing)
	{
		[self setEditing:NO animated:YES];
	}
	else
	{
		[self setEditing:YES animated:YES];
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSIndexPath* beerIndex;
        BeerViewM* beerView;
        
        if (aTableView == self.searchDisplayController.searchResultsTableView)
        {
            beerView = [self.filteredItemArray objectAtIndex:indexPath.row];
            beerIndex = [NSIndexPath indexPathForItem:[self.itemsArray indexOfObject:beerView] inSection:indexPath.section];
            
            [self removeFromFavorites:beerView onComplete:^(NSError *error)
            {
                if (error == nil)
                {
                    [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:beerIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }];
        }
        else
        {
            beerView = [self.itemsArray objectAtIndex:indexPath.row];
            [self removeFromFavorites:beerView onComplete:^(NSError *error)
             {
                 if (error == nil)
                 {                     
                     [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                 }
             }];
        }
    }
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    if (self.SegFavoriteListType.selectedSegmentIndex == 1 && FBSession.activeSession.isOpen)
    {
        [self.tableView setHidden:NO];
        [self.fbLoginView setHidden:YES];
    }
    
    if (self.isViewLoaded && self.view.window)
    {
        if ([NSString isNullOrEmpty:[GeneralDataStore sharedDataStore].FBUserID])
        {
            NSDictionary* param = @{@"userId": user.id};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_FB_LoggedIn object:nil userInfo:param];
        
        }        
        
        [self loadData];
    }
    else
    {
        [self performSelector:@selector(loadData) withObject:nil afterDelay:1];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    if (self.isViewLoaded && self.view.window)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:GlobalMessage_FB_LoggedOut object:nil userInfo:nil];
    }
    
    if (self.SegFavoriteListType.selectedSegmentIndex == 1 && !FBSession.activeSession.isOpen)
    {
        [self.tableView setHidden:YES];
        [self.fbLoginView setHidden:NO];
    }
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    // Facebook SDK * error handling *
    // Error handling is an important part of providing a good user experience.
    // Since this sample uses the FBLoginView, this delegate will respond to
    // login failures, or other failures that have closed the session (such
    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
    // and [- requestPermissionAndPost] on `SCViewController` for further
    // error handling on other operations.
    
    if (error.fberrorShouldNotifyUser)
    {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    }
    else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession)
    {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    }
    else if (error.fberrorCategory == FBErrorCategoryUserCancelled)
    {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    }
    else
    {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage)
    {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
