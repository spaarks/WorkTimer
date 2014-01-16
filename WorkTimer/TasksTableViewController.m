//
//  TasksTableViewController.m
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "TasksTableViewController.h"


#pragma mark -

@implementation TasksTableViewController

@synthesize workTimerTasks = _workTimerTasks;
@synthesize parser = _parser;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *doneItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(refreshTable)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    [self refreshTable];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedRowIndexPath != nil) {
        [self.tableView deselectRowAtIndexPath:selectedRowIndexPath animated:NO];
    }
}

// This method will be called repeatedly - once each time the user choses to parse.
- (void)parseWithParserType:(XMLParserType)parserType {
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Allocate the array for song storage, or empty the results of previous parses
    if (self.workTimerTasks == nil) {
        self.workTimerTasks = [NSMutableArray array];
    } else {
        [self.workTimerTasks removeAllObjects];
        [self.tableView reloadData];
    }
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.workTimerTasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"MyCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    WorkTimerTask* task = [self.workTimerTasks objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",[task taskKey], [task taskSummary]];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (IBAction)refreshTable {
    [self parseWithParserType:XMLParserTypeJIRAParser];
}


#pragma mark - TaskParserDelegate

- (void)parserDidEndParsingData:(TaskParser *)parser {
    //Remove duplicates
    NSSet *workTimerTasksSet = [NSSet setWithArray:self.workTimerTasks];
    NSArray *noDuplicates = [workTimerTasksSet allObjects];
    
    //Sort Alphabetically
    NSSortDescriptor *taskKeyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"taskKey" ascending:YES];
    NSArray *sortDescriptors = @[taskKeyDescriptor];
    noDuplicates = [noDuplicates sortedArrayUsingDescriptors:sortDescriptors];
    
    [self.workTimerTasks removeAllObjects];
    [self.workTimerTasks addObjectsFromArray:noDuplicates];
    
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.parser = nil;
}

- (void)parser:(TaskParser *)parser didParseWorkTimerTasks:(NSArray *)parsedWorkTimerTasks {
    [self.workTimerTasks addObjectsFromArray:parsedWorkTimerTasks];
    
    if (!self.tableView.dragging && !self.tableView.tracking && !self.tableView.decelerating) {
        [self.tableView reloadData];
    }
}

- (void)parser:(TaskParser *)parser didFailWithError:(NSError *)error {
    // handle errors as appropriate to your application...
    
}

@end

