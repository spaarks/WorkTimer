//
//  TimerTasksTableViewController.m
//  WorkTimer
//
//  Created by martin steel on 03/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "TimerTasksTableViewController.h"

@implementation TimerTasksTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [styling setNavigationBarStyling:self.navigationController.navigationBar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.navigationItem.titleView = [self getRefreshButton];
    self.navigationItem.rightBarButtonItem = [self getSettingsButton];
    
    [self populateGridOrShowSettings];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIBarButtonItem*) getSettingsButton
{
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(goToSettings)];
    
    return settingsButton;
}

-(UIButton*) getRefreshButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [refreshButton addTarget:self
                  action:@selector(refreshGrid)
        forControlEvents:UIControlEventTouchUpInside];

    [refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    
    return refreshButton;
}

- (void)populateGridOrShowSettings
{
    if(![SettingsRepository doSettingsExist])
        [self performSegueWithIdentifier:@"chooseSettingsSegue" sender:self];
    else if([self isTasksListEmpty])
        [self parseWithParserType:XMLParserTypeJIRAParser];
}

- (BOOL)isTasksListEmpty
{
    return self.workTimerTasks == nil || self.workTimerTasks.count==0;
}

-(void)refreshWorkTimerTasks
{
    if (self.workTimerTasks == nil)
    {
        self.workTimerTasks = [NSMutableArray array];
    }
    else
    {
        [self.workTimerTasks removeAllObjects];
        [self.tableView reloadData];
    }
}

//This method will be called repeatedly
- (void)parseWithParserType:(XMLParserType)parserType
{
    self.navigationItem.rightBarButtonItem.enabled = NO;

    [self refreshWorkTimerTasks];

    // Determine the Class for the parser
    Class parserClass = nil;
    switch (parserType) {
        case XMLParserTypeJIRAParser: {
            parserClass = [JIRATaskParser class];
        } break;
        default: {
            NSAssert1(NO, @"Unknown parser type %d", parserType);
        } break;
    }
    // Create the parser, set its delegate, and start it.
    self.parser = [[parserClass alloc] init];
    self.parser.delegate = self;
    [self.parser start];
}

- (IBAction)refreshGrid
{
    [self parseWithParserType:XMLParserTypeJIRAParser];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_workTimerTasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView
                            dequeueReusableCellWithIdentifier:@"TaskCell"];

    int row = (int)[indexPath row];

    if(row<[_workTimerTasks count])
    {
        WorkTimerTask *task = [_workTimerTasks objectAtIndex:row];
        cell.textLabel.text = task.taskKey;
        cell.detailTextLabel.text = task.taskSummary;
        
        [styling setTableTextLabelStyling:cell.textLabel];
        [styling setTableDetailTextLabelStyling:cell.detailTextLabel];
    }
    
    return cell;
}

- (void)goToSettings
{
    [self performSegueWithIdentifier:@"chooseSettingsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell* _currentCell = sender;
    
    if ([[segue identifier] isEqualToString:@"OpenTaskTimerSegue"] && _currentCell!=nil)
    {
        IPhoneEditWorkLogViewController *editView = [segue destinationViewController];
        
        WorkTimerTask *taskToEdit;
        
        NSIndexPath* _cellPath = [self.tableView indexPathForCell:_currentCell];
        int row = (int)[_cellPath row];
        
        taskToEdit = [_workTimerTasks objectAtIndex:row];
        
        [editView setCurrentWorkTimerTask:taskToEdit];
    }
}

#pragma mark - TaskParserDelegate

- (void)parserDidEndParsingData:(TaskParser *)parser
{
    //Remove duplicates
    NSSet *workTimerTasksSet = [NSSet setWithArray:self.workTimerTasks];
    NSArray *noDuplicates = [workTimerTasksSet allObjects];

    //Sort Alphabetically   
    noDuplicates = [Helpers sortArrayAlphabetically:noDuplicates :@"taskKey"];
    
    [self.workTimerTasks removeAllObjects];
    [self.workTimerTasks addObjectsFromArray:noDuplicates];

    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.parser = nil;

    self.parentViewController.view.hidden = NO;
}

- (void)parser:(TaskParser *)parser didParseWorkTimerTasks:(NSArray *)parsedWorkTimerTasks
{
    [self.workTimerTasks addObjectsFromArray:parsedWorkTimerTasks];

    if (!self.tableView.dragging && !self.tableView.tracking && !self.tableView.decelerating)
        [self.tableView reloadData];
}

- (void)parser:(TaskParser *)parser didFailWithError:(NSError *)error
{
    // handle errors as appropriate to your application...
    
}

@end
