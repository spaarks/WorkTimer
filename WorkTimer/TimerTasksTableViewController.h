//
//  TimerTasksTableViewController.h
//  WorkTimer
//
//  Created by martin steel on 03/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JIRATaskParser.h"
#import "JiraSettingsTableViewController.h"
#import "IPhoneEditWorkLogViewController.h"
#import "styling.h"

@interface TimerTasksTableViewController : UITableViewController<ProtocolTaskParserDelegate>


@property (nonatomic, strong) NSMutableArray *workTimerTasks;
@property (nonatomic, strong) TaskParser *parser;

@end
