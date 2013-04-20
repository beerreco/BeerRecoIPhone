//
//  BeerCategoriesViewController.m
//  BeerReco
//
//  Created by RLemberg on 4/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "BeerCategoriesViewController.h"

@interface BeerCategoriesViewController ()

@property (nonatomic, strong) LoadErrorViewController* loadErrorViewController;

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (strong,nonatomic) NSMutableArray *itemsArray;
@property (strong,nonatomic) NSMutableArray *filteredItemArray;

@end

@implementation BeerCategoriesViewController

@synthesize loadErrorViewController = _loadErrorViewController;
@synthesize HUD = _HUD;
@synthesize itemsArray = _itemsArray;
@synthesize filteredItemArray = _filteredItemArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    
    return self;
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
    [self setCategoriesSearchBar:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

-(void)visualSetup
{
    [self setTitle:@"Categories"];
    
    // Don't show the scope bar or cancel button until editing begins
    [self.categoriesSearchBar setShowsScopeBar:NO];
    [self.categoriesSearchBar sizeToFit];
    
    [self performSelector:@selector(hideSearchBar) withObject:nil afterDelay:0.5];
}

-(void)setup
{
    [self loadData];
}

-(void)hideSearchBar
{
    // Hide the search bar until user scrolls up
    CGRect newBounds = [[self tableView] bounds];
    newBounds.origin.y = newBounds.origin.y + self.categoriesSearchBar.bounds.size.height;
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
    
    [[ComServices sharedComServices].categoriesService getAllCategories:^(NSMutableArray *categories, NSError *error) 
     {
         if (error == nil && categories != nil)
         {             
             self.itemsArray = [NSMutableArray arrayWithArray:categories];
             
             [self dataLoaded];
         }
         else
         {
             [self showErrorView];
         }
         
         [self.HUD hide:YES];
     }];
}

-(void)dataLoaded
{
    // Initialize the filteredCandyArray with a capacity equal to the candyArray's capacity
    self.filteredItemArray = [NSMutableArray arrayWithCapacity:self.itemsArray.count];
    
    [self.tableView reloadData];
    
    if (self.loading == YES)
    {
        self.loading = NO;
    }
}

#pragma mark - Action Handlers

- (IBAction)showSearchClicked:(id)sender
{
    if (self.loadErrorViewController != nil)
    {
        return;
    }
    
    // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
    // Note that if you didn't hide your search bar, you should probably not include this, as it would be redundant
    [self.categoriesSearchBar becomeFirstResponder];
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.filteredItemArray removeAllObjects];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    NSArray *tempArray = [self.itemsArray filteredArrayUsingPredicate:predicate];
    
    self.filteredItemArray = [NSMutableArray arrayWithArray:tempArray];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"beerDetailsSegue"])
    {
        UIViewController *beersViewController = [segue destinationViewController];
        
        // In order to manipulate the destination view controller, another check on which table (search or normal) is displayed is needed
        if (sender == self.searchDisplayController.searchResultsTableView)
        {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSString *destinationTitle = [[self.filteredItemArray objectAtIndex:indexPath.row] name];
            [beersViewController setTitle:destinationTitle];
        }
        else
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSString *destinationTitle = [[self.itemsArray objectAtIndex:indexPath.row] name];
            [beersViewController setTitle:destinationTitle];
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
        return [self.filteredItemArray count];
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
    BeerCategoryM *beerCategory = nil;
    
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        beerCategory = [self.filteredItemArray objectAtIndex:indexPath.row];
    }
	else
	{
        beerCategory = [self.itemsArray objectAtIndex:indexPath.row];
    }
    
    // Configure the cell
    [cell.textLabel setText:beerCategory.name];
    
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
    [self performSegueWithIdentifier:@"BeersInCategorySegue" sender:tableView];
    
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
