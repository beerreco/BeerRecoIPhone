//
//  SecondViewController.m
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@property (nonatomic) int previousSelectedScopeIndex;

@end

@implementation SearchViewController

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
    [self setSearchBar:nil];
    [self setSegSearch:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

-(void)visualSetup
{
    [self setTitle:@"Search"];
    
    [self addScopesToSearchBar];
}

-(void)setup
{
}

-(void)addScopesToSearchBar
{
    int currIndex = self.searchBar.selectedScopeButtonIndex;
    
    if (self.segSearch.selectedSegmentIndex == 0)
    {
        self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Name", @"Type", @"Origin", nil];
        self.searchBar.selectedScopeButtonIndex = self.previousSelectedScopeIndex;
    }
    else if (self.segSearch.selectedSegmentIndex == 1)
    {
        self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Name", @"Area", nil];
        self.searchBar.selectedScopeButtonIndex = self.previousSelectedScopeIndex;
    }
    
    self.previousSelectedScopeIndex = currIndex;
    
    self.searchBar.showsScopeBar = YES;
}

#pragma mark - Search Handling



#pragma mark - Action Handlers

- (IBAction)segValueChanged:(id)sender
{
    [self addScopesToSearchBar];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchBar resignFirstResponder];    
}

@end
