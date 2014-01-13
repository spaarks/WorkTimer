//
//  TasksTableViewController.h
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskParser.h"
#import "JIRATaskParser.h"

@interface TasksTableViewController : UIViewController <UITableViewDelegate,
UITableViewDataSource,ProtocolTaskParserDelegate>

@property (nonatomic, strong) NSMutableArray *workTimerTasks;
@property (nonatomic, strong) TaskParser *parser;

- (void)parseWithParserType:(XMLParserType)parserType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
