//
//  FirstViewController.m
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FavoriteBeersViewController.h"

@interface FavoriteBeersViewController ()

@property (nonatomic, strong) LoadErrorViewController* loadErrorViewController;

@property (strong, nonatomic) FBLoginView *fbLoginView;
@property (strong, nonatomic) UIBarButtonItem *btnEditFaforites;

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (strong,nonatomic) NSMutableArray *publicFavoritesArray;
@property (strong,nonatomic) NSMutableArray *privateFavoritesArray;
@property (strong,nonatomic) NSMutableArray *itemsArray;
@property (strong,nonatomic) NSMutableArray *filteredItemsArray;

@end

@implementation FavoriteBeersViewController

@synthesize loadErrorViewController = _loadErrorViewController;

@synthesize HUD = _HUD;

@synthesize fbLoginView = _fbLoginView;
@synthesize btnEditFaforites = _btnEditFaforites;

@synthesize publicFavoritesArray = _publicFavoritesArray;
@synthesize privateFavoritesArray = _privateFavoritesArray;

@synthesize itemsArray = _itemsArray;
@synthesize filteredItemsArray = _filteredItemsArray;
@synthesize SegFavoriteListType = _SegFavoriteListType;
@synthesize favoritesSearchBar = _favoritesSearchBar;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [self setSegFavoriteListType:nil];
    [self setFavoritesSearchBar:nil];
    [self setFbLoginView:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

-(void)visualSetup
{
    if (self.btnEditFaforites == nil)
    {
        self.btnEditFaforites = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPrivateFavoritesTable:)];
    }
    
    // Don't show the scope bar or cancel button until editing begins
    [self.favoritesSearchBar setShowsScopeBar:NO];
    [self.favoritesSearchBar sizeToFit];
    
    [self performSelector:@selector(hideSearchBar) withObject:nil afterDelay:0.1];
}

-(void)setup
{
    [self loadData];
}

-(void)hideSearchBar
{
    // Hide the search bar until user scrolls up
    CGRect newBounds = [[self tableView] bounds];
    newBounds.origin.y = newBounds.origin.y + self.favoritesSearchBar.bounds.size.height;
    [self.tableView setBounds:newBounds];
}

-(LoadErrorViewController*)getErrorViewController
{
    if (self.loadErrorViewController == nil)
    {
        self.loadErrorViewController = [[LoadErrorViewController alloc] initWithNibName:@"LoadErrorViewController" bundle:nil];
        self.loadErrorViewController.delegate = self;
    }
    
    return self.loadErrorViewController;
}

-(void)showErrorView
{
    if (self.loadErrorViewController)
    {
        return;
    }
    
    CGRect endFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGRect startFrame = CGRectMake(endFrame.origin.x, endFrame.size.height, endFrame.size.width, endFrame.size.height);
    
    [self presentFloatingViewController:[self getErrorViewController] startFrame:startFrame endFrame:endFrame completion:^(BOOL finished)
     {
         
     }];
}

-(void)loadData
{
    if (self.HUD == nil)
    {
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.dimBackground = YES;
    }
    
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
                self.publicFavoritesArray = beers;
                
                self.itemsArray = [NSMutableArray arrayWithArray:self.publicFavoritesArray];
                
                [self dataLoaded];
            }
            else
            {
                [self showErrorView];
            }
            
            [self.HUD hide:YES];
        }];
    }
    else
    {        
        [self.navigationItem setLeftBarButtonItem:self.btnEditFaforites];
        
        [[ComServices sharedComServices].favoriteBeersService getFavoriteBeersForUser:^(NSMutableArray *beers, NSError *error)
         {
             if (error == nil && beers != nil)
             {
                 self.privateFavoritesArray = beers;
                 
                 self.itemsArray = [NSMutableArray arrayWithArray:self.privateFavoritesArray];
                 
                 [self dataLoaded];
             }
             else
             {
                 [self showErrorView];
             }
             
             [self.HUD hide:YES];
         }];
    }
}

-(void)dataLoaded
{
    // Initialize the filteredCandyArray with a capacity equal to the candyArray's capacity
    self.filteredItemsArray = [NSMutableArray arrayWithCapacity:self.itemsArray.count];
    
    [self.tableView reloadData];
    
    if (self.loading == YES)
    {
        self.loading = NO;
    }
}

-(void)removeFromFavorites:(BeerM*)beer onComplete:(void (^)(NSError *error))onComplete
{
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.dimBackground = YES;
    
    [[ComServices sharedComServices].favoriteBeersService removeBeerFromFavorites:beer.id onComplete:^(NSError *error)
    {
        if (error == nil)
        {
            [self.itemsArray removeObject:beer];
            [self.filteredItemsArray removeObject:beer];
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

#pragma mark - Action Handlers

- (IBAction)showSearchClicked:(UIBarButtonItem *)sender
{
    if (self.loadErrorViewController != nil)
    {
        return;
    }
    
    // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
    // Note that if you didn't hide your search bar, you should probably not include this, as it would be redundant
    [self.favoritesSearchBar becomeFirstResponder];
}

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

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.filteredItemsArray removeAllObjects];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    NSArray *tempArray = [self.itemsArray filteredArrayUsingPredicate:predicate];
    
    self.filteredItemsArray = [NSMutableArray arrayWithArray:tempArray];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"beerDetailsSegue"])
    {
        UIViewController *beerDetailsViewController = [segue destinationViewController];
        
        // In order to manipulate the destination view controller, another check on which table (search or normal) is displayed is needed
        if (sender == self.searchDisplayController.searchResultsTableView)
        {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            BeerViewM* beerView = [self.filteredItemsArray objectAtIndex:indexPath.row];
            
            NSString *destinationTitle = [beerView.beer name];
            [beerDetailsViewController setTitle:destinationTitle];
        }
        else
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            BeerViewM* beerView = [self.itemsArray objectAtIndex:indexPath.row];
            
            NSString *destinationTitle = [beerView.beer name];
            [beerDetailsViewController setTitle:destinationTitle];
        }
    }
}

#pragma mark - PullToRefreshViewController

-(void)doRefresh
{
    self.loading = YES;

    [self performSelector:@selector(loadData) withObject:nil afterDelay:1];
}

-(void)reloading
{
    
}

-(void)reloaded
{
    [self hideSearchBar];
}

#pragma mark - LoadErrorDelegate

-(void)reloadRequested
{
    [self.loadErrorViewController removeFloatingViewControllerFromParent:^(BOOL finished)
    {
        [self setLoadErrorViewController:nil];
        
        [self loadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredItemsArray count];
    }
	else
	{
        return [self.itemsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Create a new Candy Object
    BeerViewM *beerView = nil;
    
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        beerView = [self.filteredItemsArray objectAtIndex:indexPath.row];
    }
	else
	{
        beerView = [self.itemsArray objectAtIndex:indexPath.row];
    }
    
    // Configure the cell
    [cell.textLabel setText:beerView.beer.name];
    [cell.detailTextLabel setText:beerView.beerCategory.name];
    [cell.imageView setImage:[UIImage imageNamed:@"weihenstephaner_hefe_icon"]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setEditingAccessoryType:UITableViewCellAccessoryNone];
    
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
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform segue to beer detail
    [self performSegueWithIdentifier:@"beerDetailsSegue" sender:tableView];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSIndexPath* beerIndex;
        BeerM* beer;
        
        if (aTableView == self.searchDisplayController.searchResultsTableView)
        {
            beer = [self.filteredItemsArray objectAtIndex:indexPath.row];
            beerIndex = [NSIndexPath indexPathForItem:[self.itemsArray indexOfObject:beer] inSection:indexPath.section];
            
            [self removeFromFavorites:beer onComplete:^(NSError *error)
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
            beer = [self.itemsArray objectAtIndex:indexPath.row];
            [self removeFromFavorites:beer onComplete:^(NSError *error)
             {
                 if (error == nil)
                 {
                     [self.searchDisplayController.searchResultsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                     
                     [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                 }
             }];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self hideSearchBar];
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

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
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
