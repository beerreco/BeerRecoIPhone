//
//  FirstViewController.m
//  BeerReco
//
//  Created by RLemberg on 2/23/13.
//  Copyright (c) 2013 Colman. All rights reserved.
//

#import "RecentBeersViewController.h"

@interface RecentBeersViewController ()

@end

@implementation RecentBeersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self visualSetup];
    //sssffddd
    
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setTbRecentBeers:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

-(void)visualSetup
{
    [super visualSetup];
    
    self.title = LocalizedString(@"RecentBeers_Title");
}

-(void)setup
{
    /*
    self.cellTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TableW, TableH) style:UITableViewStylePlain];
    [self.cellTable registerNib:[UINib nibWithNibName:@"TopicGaugeTableCell" bundle:nil] forCellReuseIdentifier:TOPIC_GAUGE_CELL_ID];
    [self.cellTable registerNib:[UINib nibWithNibName:@"TopicDetailsTableCell" bundle:nil] forCellReuseIdentifier:TOPIC_DETAILS_CELL_ID];
    [self.cellTable registerNib:[UINib nibWithNibName:@"TopicReportTableCell" bundle:nil] forCellReuseIdentifier:TOPIC_REPORT_CELL_ID];
    [self.cellTable registerNib:[UINib nibWithNibName:@"TopicVideoTableCell" bundle:nil] forCellReuseIdentifier:TOPIC_VIDEO_CELL_ID];
    
    [self.cellTable setSeparatorColor:[UIColor colorWithHexString:@"262626"]];
    self.cellTable.delegate = self;
    self.cellTable.dataSource = self;
    self.cellTable.backgroundColor = [UIColor clearColor];
    [self addSubview:self.cellTable];*/
}

-(void)loadData
{
    self.loading = YES;
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1];
}

-(void)stopLoading
{
    self.loading = NO;
}

#pragma mark - PullToRefreshViewController

-(void)doRefresh
{
    [self loadData];
}

#pragma mark - UITableViewDataSource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = 5;//self.topicOnWall == nil ? 0 : 1 + self.topicOnWall.gaugesList.count + 1 + 1;
    
    return number;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (indexPath.row == 0)
    {
        TopicDetailsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPIC_DETAILS_CELL_ID];
        [cell setTopic:self.topicOnWall.topic];
        [cell markAsPressable:YES];
        
        return cell;
    }
    else if (indexPath.row > 0 && indexPath.row <= self.topicOnWall.gaugesList.count)
    {
        TopicGaugeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPIC_GAUGE_CELL_ID];
        GaugeM* currentGauge = [self.topicOnWall.gaugesList objectAtIndex:indexPath.row - 1];
        [cell setGauge:currentGauge];
        
        return cell;
    }
    else if (indexPath.row == self.topicOnWall.gaugesList.count + 1)
    {
        TopicReportTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPIC_REPORT_CELL_ID];
        [cell setSummaryReport:self.topicOnWall.lastSummary];
        
        return cell;
    }
    else if (indexPath.row == self.topicOnWall.gaugesList.count + 2)
    {
        TopicVideoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TOPIC_VIDEO_CELL_ID];
        [cell setVideoBriefing:self.topicOnWall.lastBriefing];
        
        
        return cell;
    }
     */
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
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
    //[self.cellTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
