//
//  FirstViewController.m
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "FavoriteBeersViewController.h"

@interface FavoriteBeersViewController ()

@end

@implementation FavoriteBeersViewController

@synthesize candyArray = _candyArray;
@synthesize filteredCandyArray = _filteredCandyArray;
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
    [super viewDidUnload];
}

#pragma mark - Private Methods

-(void)visualSetup
{    
    // Don't show the scope bar or cancel button until editing begins
    [self.favoritesSearchBar setShowsScopeBar:NO];
    [self.favoritesSearchBar sizeToFit];
    
    [self hideSearchBar];
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
    [[self tableView] setBounds:newBounds];
}

-(void)loadData
{    
    if (self.SegFavoriteListType.selectedSegmentIndex == 0)
    {
        self.candyArray = [NSArray arrayWithObjects:
                           [BeerM beerOfCategory:@"chocolate" name:@"chocolate bar"],
                           [BeerM beerOfCategory:@"chocolate" name:@"chocolate chip"],
                           [BeerM beerOfCategory:@"chocolate" name:@"dark chocolate"],
                           [BeerM beerOfCategory:@"hard" name:@"lollipop"],
                           [BeerM beerOfCategory:@"hard" name:@"candy cane"],
                           [BeerM beerOfCategory:@"hard" name:@"jaw breaker"],
                           [BeerM beerOfCategory:@"other" name:@"caramel"],
                           [BeerM beerOfCategory:@"other" name:@"sour chew"],
                           [BeerM beerOfCategory:@"other" name:@"peanut butter cup"],
                           [BeerM beerOfCategory:@"other" name:@"gummi bear"], nil];
    }
    else
    {
        self.candyArray = [NSArray arrayWithObjects:
                           [BeerM beerOfCategory:@"chocolate" name:@"kaka"],
                           [BeerM beerOfCategory:@"chocolate" name:@"kaka 2"],
                           [BeerM beerOfCategory:@"chocolate" name:@"kaka 3"], nil];
    }    
    
    // Initialize the filteredCandyArray with a capacity equal to the candyArray's capacity
    self.filteredCandyArray = [NSMutableArray arrayWithCapacity:self.candyArray.count];
    
    [self.tableView reloadData];    
}

-(void)stopLoading
{
    self.loading = NO;
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.filteredCandyArray removeAllObjects];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    NSArray *tempArray = [self.candyArray filteredArrayUsingPredicate:predicate];
    
    self.filteredCandyArray = [NSMutableArray arrayWithArray:tempArray];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"beerDetails"])
    {
        UIViewController *candyDetailViewController = [segue destinationViewController];
        
        // In order to manipulate the destination view controller, another check on which table (search or normal) is displayed is needed
        if(sender == self.searchDisplayController.searchResultsTableView)
        {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSString *destinationTitle = [[self.filteredCandyArray objectAtIndex:[indexPath row]] name];
            [candyDetailViewController setTitle:destinationTitle];
        }
        else
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSString *destinationTitle = [[self.candyArray objectAtIndex:[indexPath row]] name];
            [candyDetailViewController setTitle:destinationTitle];
        }
    }
}

#pragma mark - PullToRefreshViewController

-(void)doRefresh
{
    self.loading = YES;
    
    [self loadData];
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1];
}

-(void)reloading
{
    
}

-(void)reloaded
{
    [self hideSearchBar];
}

#pragma mark - UITableViewDataSource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredCandyArray count];
    }
	else
	{
        return [self.candyArray count];
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Create a new Candy Object
    BeerM *beer = nil;
    
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        beer = [self.filteredCandyArray objectAtIndex:[indexPath row]];
    }
	else
	{
        beer = [self.candyArray objectAtIndex:[indexPath row]];
    }
    
    // Configure the cell
    [[cell textLabel] setText:[beer name]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 44;
}

// fixed font style. use custom view (UILabel) if you want something different
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

#pragma mark - UITableViewDelegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform segue to candy detail
    [self performSegueWithIdentifier:@"beerDetails" sender:tableView];
    //[self.cellTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self hideSearchBar];
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

#pragma mark - Action Handlers

- (IBAction)showSearchClicked:(UIBarButtonItem *)sender
{
    // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
    // Note that if you didn't hide your search bar, you should probably not include this, as it would be redundant
    [self.favoritesSearchBar becomeFirstResponder];
}

- (IBAction)favoriteListTypeChanged:(UISegmentedControl *)sender forEvent:(UIEvent *)event
{
    [self loadData];
}

@end
