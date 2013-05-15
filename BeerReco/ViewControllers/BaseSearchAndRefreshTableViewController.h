//
//  BaseSearchAndRefreshTableViewController.h
//  BeerReco
//
//  Created by RLemberg on 5/10/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "PullToRefreshViewController.h"
#import "MBProgressHUD.h"
#import "LoadErrorViewController.h"

#import <Foundation/Foundation.h>

@interface BaseSearchAndRefreshTableViewController : PullToRefreshViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, MBProgressHUDDelegate, LoadErrorDelegate>

@property (nonatomic, strong) LoadErrorViewController* loadErrorViewController;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* tableToButtomConstraint;
@property (nonatomic, weak) IBOutlet UIToolbar* buttomToolBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* barBtnEdit;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* barBtnAdd;

@property (strong,nonatomic) NSMutableArray *itemsArray;
@property (strong,nonatomic) NSMutableArray *filteredItemArray;

-(void)loadData;
-(void)showErrorView;
-(void)dataLoaded:(NSMutableArray*)data;

#pragma mark - virtuals
-(void)loadCurrentData;
-(BOOL)canShowContributionToolBar;
-(BOOL)shouldSortItemsList;
-(NSString*)getSortingKeyPath;
-(NSString*)getSearchablePropertyName;
-(NSString*)getCellIdentifier;
-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
-(void)tableItemSelected:(NSIndexPath *)indexPath;
-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object;
-(void)addNewItem;
-(void)toggleEditMode;

- (IBAction)contributionEditClicked:(UIBarButtonItem *)sender;
- (IBAction)contributionAddClicked:(UIBarButtonItem *)sender;

@end
