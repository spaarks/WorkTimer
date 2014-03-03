//
//  ButtonGridViewController.m
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "ButtonGridViewController.h"

@implementation ButtonGridViewController

@synthesize workTimerTasks = _workTimerTasks;
@synthesize parser = _parser;
@synthesize selectedCellIndices = _selectedCellIndices;

bool reparseTasks = true;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _selectedCellIndices = [[NSMutableArray alloc] init];
    
    [self populateGridOrShowSettings];
}

- (void)populateGridOrShowSettings
{
    if(![Repository doSettingsExist])
    {
        [self performSegueWithIdentifier:@"openSettingsSegue" sender:self];
    }
    else
    {
        //self.parentViewController.view.hidden = YES;
        
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [refreshButton addTarget:self
                          action:@selector(refreshGrid)
                forControlEvents:UIControlEventTouchUpInside];
        
        [refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
        
        self.navigationItem.titleView = refreshButton;
        
        if(reparseTasks)
            [self parseWithParserType:XMLParserTypeJIRAParser];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshGrid {
    [self viewWillAppear:YES];
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
        [self.collectionView reloadData];
    }
}

// This method will be called repeatedly
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

-(WorkTimerTask*)fetchWorkTimerTaskForRunningCell
{
    //Assume that the first cell in the array is the running cell
    //There should only be one running timer
    
    if(_selectedCellIndices.count>0)
    {
        NSNumber *cellIndex = _selectedCellIndices.firstObject;
        NSIndexPath *runningCellIndexPath = [NSIndexPath indexPathForRow:[cellIndex intValue] inSection:0];
            
        ButtonGridCell *runningCell = ((ButtonGridCell*)[self.collectionView cellForItemAtIndexPath:runningCellIndexPath]);
    
        return [self getRunningWorkTimerTask:runningCell];
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate


- (void)addIndexToSelectedCells:(NSNumber*) cellIndex
{
    NSInteger indexOfCell = [_selectedCellIndices indexOfObject:cellIndex];
    
    //Only add to array if it's not already there
    if(indexOfCell == NSNotFound)
    {
        [_selectedCellIndices addObject:cellIndex];
    }
}

- (void)removeIndexFromSelectedCells:(NSNumber*) cellIndex {
     //= [NSNumber numberWithInt:[indexPath indexAtPosition:1]];
    int indexOfCell = [_selectedCellIndices indexOfObject:cellIndex];
    
    [_selectedCellIndices removeObjectAtIndex:indexOfCell];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // If you need to use the touched cell, you can retrieve it like so
    ButtonGridCell *cell = ((ButtonGridCell*)[collectionView cellForItemAtIndexPath:indexPath]);

    [self startCell:NO:cell];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    // If you need to use the touched cell, you can retrieve it like so
    ButtonGridCell *cell = ((ButtonGridCell*)[collectionView cellForItemAtIndexPath:indexPath]);

    NSNumber* indexOfCell = [NSNumber numberWithInt:[indexPath indexAtPosition:1]];
    [self removeIndexFromSelectedCells:indexOfCell];
    
    [cell tapCell:NO];
    
    NSDate * start = cell.clockView.timeStarted;
    
    NSDate *logTime = cell.clockView.currentTime;
    NSString *logTimeString = [Helpers getJIRATimeString:logTime];
    
    FakeProjectRepository *repo = [[FakeProjectRepository alloc] init];
    [repo createTimesheetLog:start
                            :logTimeString
                            :cell.comment
                            :cell.taskKeyLabel.text];
}

- (void)startCell:(BOOL)isPause
                 :(ButtonGridCell *)cell
{
    NSIndexPath* currentCellIndexPath = [self.collectionView indexPathForCell:cell];
    NSNumber *indexOfCurrentCell = [NSNumber numberWithInt:[currentCellIndexPath indexAtPosition:1]];
    
    for(NSNumber *cellIndex in _selectedCellIndices)
    {
        if([cellIndex intValue]!=[indexOfCurrentCell intValue])
        {
            [self removeIndexFromSelectedCells:cellIndex];
            
            NSIndexPath *cellToDeselectIndexPath = [NSIndexPath indexPathForRow:[cellIndex intValue] inSection:0];
            
            ButtonGridCell *cellToDeselect = ((ButtonGridCell*)[self.collectionView cellForItemAtIndexPath:cellToDeselectIndexPath]);
            [cellToDeselect tapCell:NO];
            
            NSDate * start = cellToDeselect.clockView.timeStarted;
            
            NSDate *logTime = cellToDeselect.clockView.currentTime;
            NSString *logTimeString = [Helpers getJIRATimeString:logTime];
            
            FakeProjectRepository *repo = [[FakeProjectRepository alloc] init];
            [repo createTimesheetLog:start
                                    :logTimeString
                                    :cellToDeselect.comment
                                    :cellToDeselect.taskKeyLabel.text];
        }
    }
    
    [self addIndexToSelectedCells:indexOfCurrentCell];
    [cell tapCell:YES];
}

#pragma mark - EditWorkLogButtonClickedDelegate

-(void)commitClicked:(WorkTimerTask*)task
                    :(ButtonGridCell*)currentCell
{
    NSIndexPath* currentCellIndexPath = [self.collectionView indexPathForCell:currentCell];
    NSNumber *indexOfCurrentCell = [NSNumber numberWithInt:[currentCellIndexPath indexAtPosition:1]];
    
    [self removeIndexFromSelectedCells:indexOfCurrentCell];

    NSDate * start = currentCell.clockView.timeStarted;
    
    NSString *logTimeString = task.timeWorked;
    
    FakeProjectRepository *repo = [[FakeProjectRepository alloc] init];
    [repo createTimesheetLog:start
                            :logTimeString
                            :task.taskDescription
                            :task.taskKey];
    
    [currentCell tapCell:NO];
}

-(void)cancelClicked:(ButtonGridCell*)currentCell
{
    [currentCell tapCell:YES];
}

-(void)deleteClicked:(WorkTimerTask*)task
                    :(ButtonGridCell*)currentCell
{
    NSIndexPath* currentCellIndexPath = [self.collectionView indexPathForCell:currentCell];
    NSNumber *indexOfCurrentCell = [NSNumber numberWithInt:[currentCellIndexPath indexAtPosition:1]];
    
    [self removeIndexFromSelectedCells:indexOfCurrentCell];
    
    [currentCell tapCell:NO];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [self.workTimerTasks count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ButtonGridCell *gridCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"ButtonGridCelIdentifier"
                                    forIndexPath:indexPath];
    
    gridCell.delegate = (id<ProtocolButtonClickedInCellDelegate>)self;
    
    int row = [indexPath row];
    
    if(row<[_workTimerTasks count]){
        WorkTimerTask *task = [_workTimerTasks objectAtIndex:row];
    
        gridCell.taskKeyLabel.text = task.taskKey;
        gridCell.taskSummaryLabel.text = task.taskSummary;
        
        [gridCell.clockView.activityIndicator setHidesWhenStopped:YES];
    }
    return gridCell;
}

#pragma mark - ButtonClickedInCellDelegate

- (void)startClicked:(BOOL)isPause
                    :(ButtonGridCell*)cell
{
    [self startCell:isPause:cell];
}

- (void)stopClicked:(ButtonGridCell*)cell
{
    [self performSegueWithIdentifier:@"OpenStopSegue" sender:cell];
}

- (WorkTimerTask *)getRunningWorkTimerTask:(ButtonGridCell *)_currentCell
{
    WorkTimerTask *taskToEdit = [[WorkTimerTask alloc] init];
    
    NSDate *currentTime = _currentCell.clockView.currentTime;
    NSString *currentTimeString = [Helpers getJIRATimeString:currentTime];
    
    taskToEdit.timeWorked = currentTimeString;
    taskToEdit.taskDescription = _currentCell.comment;
    
    taskToEdit.taskKey = _currentCell.taskKeyLabel.text;
    taskToEdit.taskSummary = _currentCell.taskSummaryLabel.text;
    return taskToEdit;
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ButtonGridCell* _currentCell = sender;
    
    if ([[segue identifier] isEqualToString:@"OpenStopSegue"] && _currentCell!=nil)
    {
        EditWorkLogViewController *editView = [segue destinationViewController];

        editView.currentCell = _currentCell;
        
        editView.delegate = (id<ProtocolEditWorkLogButtonClickedDelegate>)self;
        
        WorkTimerTask *taskToEdit;
        taskToEdit = [self getRunningWorkTimerTask:_currentCell];
        
        [editView setCurrentWorkTimerTask:taskToEdit];
        
        [_currentCell tapCell:YES];
    }
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
    
    self.parentViewController.view.hidden = NO;
}

- (void)parser:(TaskParser *)parser didParseWorkTimerTasks:(NSArray *)parsedWorkTimerTasks
{
    [self.workTimerTasks addObjectsFromArray:parsedWorkTimerTasks];
    
    if (!self.collectionView.dragging && !self.collectionView.tracking && !self.collectionView.decelerating) {
        [self.collectionView reloadData];
    }
}

- (void)parser:(TaskParser *)parser didFailWithError:(NSError *)error
{
    // handle errors as appropriate to your application...
    
}

#pragma mark - NSCoding

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.workTimerTasks forKey:@"WorkTimerTasks"];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];

    NSArray* tasks = [coder decodeObjectForKey:@"WorkTimerTasks"];
    
    if(tasks.count>0)
        reparseTasks = false;
    
    [self refreshWorkTimerTasks];
    [self.workTimerTasks addObjectsFromArray:tasks];
    [self.collectionView reloadData];
}

#pragma mark - UIDataSourceModelAssociation
- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)indexPath inView:(UIView *)view
{
    ButtonGridCell * cell = ((ButtonGridCell*)[self.collectionView cellForItemAtIndexPath:indexPath]);
    
    return cell.taskKeyLabel.text;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskKey==%@",identifier];
    NSArray *results = [self.workTimerTasks filteredArrayUsingPredicate:predicate];
    
    if([results count]==0)
        return nil;
    
    WorkTimerTask* task = [results objectAtIndex:0];
	NSInteger index = [self.workTimerTasks indexOfObject:task];
    
    NSIndexPath* path = [NSIndexPath indexPathForRow:index inSection:0];
    
	return path;
}

@end
