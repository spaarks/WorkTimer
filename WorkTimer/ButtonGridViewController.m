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
@synthesize selectedCellIndices = _selectedCellIndices;

int const kCellsPerPage = 20;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom ;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _selectedCellIndices = [[NSMutableArray alloc] init];
    
    [self populateGridOrShowSettings];
}

- (void)populateGridOrShowSettings
{
    if(![SettingsRepository doSettingsExist])
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

-(void)reloadCells
{
    [self.workTimerTasks removeAllObjects];
    [self.collectionView reloadData];
}

// This method will be called repeatedly
- (void)parseWithParserType:(XMLParserType)parserType {
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Allocate the array for workTimer storage, or empty the results of previous parses
    if (self.workTimerTasks == nil) {
        self.workTimerTasks = [NSMutableArray array];
    } else {
        [self reloadCells];
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


- (void)addIndexToSelectedCells:(NSNumber*) cellIndex {
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
}

- (void)startCell:(BOOL)isPause
                 :(ButtonGridCell *)cell
{
    NSIndexPath* currentCellIndexPath = [self.collectionView indexPathForCell:cell];
    NSNumber *indexOfCurrentCell = [NSNumber numberWithInt:[currentCellIndexPath indexAtPosition:1]];
    
    for(NSNumber *cellIndex in _selectedCellIndices)
    {
        if(cellIndex!=indexOfCurrentCell)
        {
            [self removeIndexFromSelectedCells:cellIndex];
            //NSIndexPath *cellToDeselectIndexPath = [NSIndexPath indexPathWithIndex:[cellIndex intValue]];
            
            NSIndexPath *cellToDeselectIndexPath = [NSIndexPath indexPathForRow:[cellIndex intValue] inSection:0];
            
            ButtonGridCell *cellToDeselect = ((ButtonGridCell*)[self.collectionView cellForItemAtIndexPath:cellToDeselectIndexPath]);
            [cellToDeselect tapCell:NO];
        }
    }
    
    [self addIndexToSelectedCells:indexOfCurrentCell];
    [cell tapCell:YES];
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
    //return 1000;//kCellsPerPage;
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
    NSIndexPath* currentCellIndexPath = [self.collectionView indexPathForCell:cell];
    NSNumber *indexOfCurrentCell = [NSNumber numberWithInt:[currentCellIndexPath indexAtPosition:1]];
    
    [self removeIndexFromSelectedCells:indexOfCurrentCell];
    [cell tapCell:NO];
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
    
    [self collectionView];
    
    if (!self.collectionView.dragging && !self.collectionView.tracking && !self.collectionView.decelerating) {
        [self.collectionView reloadData];
    }
}

- (void)parser:(TaskParser *)parser didFailWithError:(NSError *)error
{
    // handle errors as appropriate to your application...
    
}
@end
