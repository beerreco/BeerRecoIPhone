//
//  BaseSearchAndRefreshTableViewController.m
//  BeerReco
//
//  Created by RLemberg on 5/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BaseSearchAndRefreshTableViewController.h"

@interface BaseSearchAndRefreshTableViewController ()

@property (nonatomic, strong) UIBarButtonItem* barBtnShowSearch;

@end

@implementation BaseSearchAndRefreshTableViewController

@synthesize barBtnShowSearch = _barBtnShowSearch;
@synthesize loadErrorViewController = _loadErrorViewController;
@synthesize HUD = _HUD;
@synthesize itemsArray = _itemsArray;
@synthesize filteredItemArray = _filteredItemArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self baseVisualSetup];
    
    [self baseSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
}

#pragma mark - Private Methods

-(void)baseVisualSetup
{
    // Don't show the scope bar or cancel button until editing begins
    [self.searchDisplayController.searchBar setShowsScopeBar:NO];
    [self.searchDisplayController.searchBar sizeToFit];
    
    [self performSelector:@selector(hideSearchBar) withObject:nil afterDelay:0.1];
    
    if (self.barBtnShowSearch == nil)
    {
        self.barBtnShowSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchClicked:)];
    }
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.barBtnShowSearch, nil];
}

-(void)baseSetup
{
    [self loadData];
}

-(void)hideSearchBar
{
    // Hide the search bar until user scrolls up
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchDisplayController.searchBar.bounds.size.height;
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
    
    [self.HUD hide:YES];
    
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
    
    [self loadCurrentData];
}

-(void)dataLoaded:(NSMutableArray*)data
{
    self.itemsArray = [NSMutableArray arrayWithArray:data];
    
    if ([self shouldSortItemsList])
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:[self getSortingKeyPath] ascending:YES];
        [self.itemsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    // Initialize the filteredCandyArray with a capacity equal to the candyArray's capacity
    self.filteredItemArray = [NSMutableArray arrayWithCapacity:self.itemsArray.count];
    
    [self.tableView reloadData];
    
    if (self.loading == YES)
    {
        self.loading = NO;
    }
    
    [self.HUD hide:YES];
}

#pragma mark - Virtuals

-(void)loadCurrentData
{
    
}

-(BOOL)shouldSortItemsList
{
    return ![NSString isNullOrEmpty:[self getSortingKeyPath]];
}

-(NSString*)getSortingKeyPath
{
    return @"";
}

-(NSString*)getSearchablePropertyName
{
    return @"name";
}

-(NSString*)getCellIdentifier
{
    return @"cell";
}

-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    
}

-(void)tableItemSelected:(NSIndexPath *)indexPath
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object
{
    
}

#pragma mark - Action Handlers

- (void)showSearchClicked:(id)sender
{
    if (self.loadErrorViewController != nil)
    {
        return;
    }
    
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor clearColor]];
    [self.searchDisplayController.searchResultsTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_main"]]];
    
    // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
    // Note that if you didn't hide your search bar, you should probably not include this, as it would be redundant
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.filteredItemArray removeAllObjects];
    
    NSString* searchableProperty = [self getSearchablePropertyName];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = predicate = [NSPredicate predicateWithFormat:@"SELF.%@ contains[c] %@", searchableProperty, searchText];;
    
    NSArray *tempArray = [self.itemsArray filteredArrayUsingPredicate:predicate];
    
    self.filteredItemArray = [NSMutableArray arrayWithArray:tempArray];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id object;
    if (sender == self.searchDisplayController.searchResultsTableView)
    {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        object = [self.filteredItemArray objectAtIndex:indexPath.row];
    }
    else
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        object = [self.itemsArray objectAtIndex:indexPath.row];
    }
    
    [self prepareForSegue:segue withObject:object];
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
        return [self.filteredItemArray count];
    }
	else
	{
        return [self.itemsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self getCellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    id object;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        object = [self.filteredItemArray objectAtIndex:indexPath.row];
    }
	else
	{
        object = [self.itemsArray objectAtIndex:indexPath.row];
    }
    
    [self setupCell:cell forIndexPath:indexPath withObject:object];
    
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
    [self tableItemSelected:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

@end
