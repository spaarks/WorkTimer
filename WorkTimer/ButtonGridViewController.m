//
//  ButtonGridViewController.m
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "ButtonGridViewController.h"

@interface ButtonGridViewController ()

@end

@implementation ButtonGridViewController

@synthesize workTimerTasks = _workTimerTasks;
@synthesize parser = _parser;

int const kCellsPerPage = 20;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *doneItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(refreshGrid)];
    self.navigationItem.rightBarButtonItem = doneItem;

    [self refreshGrid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshGrid {
    //Refresh the data
    
    [self parseWithParserType:XMLParserTypeJIRAParser];
}

// This method will be called repeatedly - once each time the user choses to parse.
- (void)parseWithParserType:(XMLParserType)parserType {
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Allocate the array for workTimer storage, or empty the results of previous parses
    if (self.workTimerTasks == nil) {
        self.workTimerTasks = [NSMutableArray array];
    } else {
        [self.workTimerTasks removeAllObjects];
        [self.collectionView reloadData];
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

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // If you need to use the touched cell, you can retrieve it like so
    ButtonGridCell *cell = ((ButtonGridCell*)[collectionView cellForItemAtIndexPath:indexPath]);
    
    [cell tapCell:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    // If you need to use the touched cell, you can retrieve it like so
    ButtonGridCell *cell = ((ButtonGridCell*)[collectionView cellForItemAtIndexPath:indexPath]);

    [cell tapCell:NO];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView{
    //return MIN([_workTimerTasks count], kCellsPerPage)
    return 1;
    
    //if([_workTimerTasks count] < kCellsPerPage)
    //    return 1;
    
    //return [_workTimerTasks count]/kCellsPerPage;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return 1000;//kCellsPerPage;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ButtonGridCell *gridCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"ButtonGridCelIdentifier"
                                    forIndexPath:indexPath];
    
    int row = [indexPath row];
    
    if(row<[_workTimerTasks count]){
        WorkTimerTask *task = [_workTimerTasks objectAtIndex:row];
    
        gridCell.taskKeyLabel.text = task.taskKey;
        gridCell.taskSummaryLabel.text = task.taskSummary;
        
        [gridCell.clockView.activityIndicator setHidesWhenStopped:YES];
    }
    return gridCell;
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
    
    [self.collectionView reloadData];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.parser = nil;
}

- (void)parser:(TaskParser *)parser didParseWorkTimerTasks:(NSArray *)parsedWorkTimerTasks {
    [self.workTimerTasks addObjectsFromArray:parsedWorkTimerTasks];
    
    [self collectionView];
    
    if (!self.collectionView.dragging && !self.collectionView.tracking && !self.collectionView.decelerating) {
        [self.collectionView reloadData];
    }
}

- (void)parser:(TaskParser *)parser didFailWithError:(NSError *)error {
    // handle errors as appropriate to your application...
    
}
@end
