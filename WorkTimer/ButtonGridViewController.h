//
//  ButtonGridViewController.h
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskParser.h"
#import "JIRATaskParser.h"
#import "ButtonGridCell.h"
#import "ProtocolButtonClickedInCellDelegate.h"
#import "EditWorkLogViewController.h"
#import "JiraSettingsTableViewController.h"

@interface ButtonGridViewController : UICollectionViewController
<UICollectionViewDataSource, UICollectionViewDelegate,ProtocolTaskParserDelegate, ProtocolButtonClickedInCellDelegate,ProtocolEditWorkLogButtonClickedDelegate, UIDataSourceModelAssociation
, NSCoding
>

@property (nonatomic, strong) NSMutableArray *workTimerTasks;
@property (nonatomic, strong) TaskParser *parser;

@property (nonatomic, strong) NSMutableArray *selectedCellIndices;

- (void)parseWithParserType:(XMLParserType)parserType;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
