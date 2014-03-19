////
////  EditWorkLogViewController.m
////  WorkTimer
////
////  Created by martin steel on 30/01/2014.
////  Copyright (c) 2014 martin steel. All rights reserved.
////
//
//#import "EditWorkLogViewController.h"
//
//@implementation EditWorkLogViewController
//
//@synthesize currentWorkTimerTask = _currentWorkTimerTask;
//@synthesize currentCell = _currentCell;
//
//- (id)initWithCoder:(NSCoder*)aDecoder
//{
//    if(self = [super initWithCoder:aDecoder]) {
//        if(!_currentWorkTimerTask)
//            _currentWorkTimerTask = [[WorkTimerTask alloc] init];
//    }
//    return self;
//}
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    //self.projectTextField.text = _currentWorkTimerTask.
//    self.taskTextField.text = [NSString stringWithFormat:@"%@ - %@",_currentWorkTimerTask.taskKey,_currentWorkTimerTask.taskSummary];
//    self.descriptionTextField.text = _currentWorkTimerTask.taskDescription;
//    self.timeWorkedTextField.text = _currentWorkTimerTask.timeWorked;
//}
//
//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    self.view.superview.bounds = CGRectMake(0, 0, 640, 320);
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of ainy resources that can be recreated.
//}
//
//
//- (IBAction)descriptionDidEndEditing:(id)sender
//{
//    [self checkDescription];
//}
//
//-(void)checkDescription
//{
//    _currentWorkTimerTask.taskDescription = self.descriptionTextField.text;
//    self.descriptionInvalidImage.hidden = [_currentWorkTimerTask isDescriptionValid];
//}
//
//- (IBAction)timeWorkedDidEndEditing:(id)sender
//{
//    [self checkTimeWorked];
//}
//
//-(void)checkTimeWorked
//{
//    _currentWorkTimerTask.timeWorked = self.timeWorkedTextField.text;
//    self.timeWorkedInvalidImage.hidden = [_currentWorkTimerTask isTimeWorkedValid];
//}
//
//-(BOOL)validateAllFields
//{
//    [self checkTimeWorked];
//    [self checkDescription];
//    
//    return [_currentWorkTimerTask isTimeWorkedValid] &&
//    [_currentWorkTimerTask isDescriptionValid];
//}
//
//- (IBAction)commitTouchUpInside:(id)sender
//{
//    if(![self validateAllFields])
//        return;
//
//    [self.delegate commitClicked:_currentWorkTimerTask:_currentCell];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (IBAction)deleteTouchUpInside:(id)sender
//{
//    [self.delegate deleteClicked:_currentWorkTimerTask:_currentCell];
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (IBAction)cancelTouchUpInside:(id)sender
//{
//    [self.delegate cancelClicked:_currentCell];
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//@end
