//
//  EditWorkLogViewController.m
//  WorkTimer
//
//  Created by martin steel on 30/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "IPhoneEditWorkLogViewController.h"

@implementation IPhoneEditWorkLogViewController
@synthesize currentWorkTimerTask = _currentWorkTimerTask;
@synthesize currentCell = _currentCell;
UIPickerView* timePicker;

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        if(!_currentWorkTimerTask)
            _currentWorkTimerTask = [[WorkTimerTask alloc] init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.descriptionTextField setDelegate:self];
    
    self.taskCodeLabel.text = _currentWorkTimerTask.taskKey;
    self.taskSummaryLabel.text = _currentWorkTimerTask.taskSummary;
    self.descriptionTextField.text = _currentWorkTimerTask.taskDescription;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(timePicker!=nil)
    {
        [self setTimePickerComponentValue:0:[Helpers getHours:_currentWorkTimerTask.timeWorkedTime]];
        [self setTimePickerComponentValue:1:[Helpers getMinutes:_currentWorkTimerTask.timeWorkedTime]];
        [self setTimePickerComponentValue:2:[Helpers getSeconds:_currentWorkTimerTask.timeWorkedTime]];
    }
}

// assumes you conform to UIPickerViewDelegate and UIPickerViewDataSource in your .h
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    timePicker.dataSource = self;
    timePicker.delegate = self;
    
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:[self getFrameForPickerLabel:0]];
    hourLabel.text = @"hour";
    [timePicker addSubview:hourLabel];
    
    UILabel *minsLabel = [[UILabel alloc] initWithFrame:[self getFrameForPickerLabel:1]];
    minsLabel.text = @"min";
    [timePicker addSubview:minsLabel];
    
    UILabel *secsLabel = [[UILabel alloc] initWithFrame:[self getFrameForPickerLabel:2]];
    secsLabel.text = @"sec";
    [timePicker addSubview:secsLabel];
    
    [self.timePickerView addSubview:timePicker];
}

- (void)setTimePickerComponentValue
                                    :(int)compenentIndex
                                    :(int)value
{
    [timePicker selectRow:value inComponent:compenentIndex animated:YES];
    [timePicker reloadComponent:compenentIndex];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.descriptionTextField resignFirstResponder];
    return YES;
}

- (CGRect)getFrameForPickerLabel:(int)index
{
    return CGRectMake([self getXPositionOfPickerLabel:index], [self getYPositionOfPickerLabel], 75, 30);
}

- (int)getXPositionOfPickerLabel:(int)pickerIndex
{
    return 42 + (timePicker.frame.size.width / 3) * pickerIndex;
}

- (int)getYPositionOfPickerLabel
{
    return timePicker.frame.size.height / 2 - 15;
}

#pragma PickerViewDelegate and PickerViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return 24;

    return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width/3 - 35, 30)];
    
    columnView.text = [NSString stringWithFormat:@"%lu", (long)row];
    columnView.textAlignment = NSTextAlignmentLeft;
    
    return columnView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)descriptionDidEndEditing:(id)sender
{
    [self checkDescription];
}

-(void)checkDescription
{
    _currentWorkTimerTask.taskDescription = self.descriptionTextField.text;
    
    self.descriptionInvalidImage.hidden = [_currentWorkTimerTask isDescriptionValid];
}

-(BOOL)validateAllFields
{
    [self checkDescription];

    return [_currentWorkTimerTask isTimeWorkedValid] && [_currentWorkTimerTask isDescriptionValid];
}

-(void)updateWorkTimerTask
{
    int hours = (int)[timePicker selectedRowInComponent:0];
    int minutes = (int)[timePicker selectedRowInComponent:1];
    int seconds = (int)[timePicker selectedRowInComponent:2];
    
    _currentWorkTimerTask.timeWorkedTime = [Helpers getDateFromComponents:hours:minutes:seconds];
    
    NSString* jiraTimeString = [Helpers getJIRATimeString:_currentWorkTimerTask.timeWorkedTime];
    _currentWorkTimerTask.timeWorked = jiraTimeString;
}

- (IBAction)commitTouchUpInside:(id)sender
{
    if(![self validateAllFields])
        return;
    
    [self updateWorkTimerTask];
    
    [self.delegate commitClicked:_currentWorkTimerTask];
}

- (IBAction)deleteTouchUpInside:(id)sender
{
    [self.delegate deleteClicked];
}

@end

