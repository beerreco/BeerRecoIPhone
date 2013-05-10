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

@property (strong,nonatomic) NSMutableArray *itemsArray;
@property (strong,nonatomic) NSMutableArray *filteredItemArray;

-(void)loadData;
-(void)showErrorView;
-(void)dataLoaded:(NSMutableArray*)data;

#pragma mark - virtuals
-(void)loadCurrentData;
-(NSString*)getSearchablePropertyName;
-(NSString*)getCellIdentifier;
-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
-(void)tableItemSelected:(NSIndexPath *)indexPath;
-(void)prepareForSegue:(UIStoryboardSegue *)segue withObject:(id)object;

@end
