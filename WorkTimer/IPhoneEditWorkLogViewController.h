//
//  EditWorkLogViewController.h
//  WorkTimer
//
//  Created by martin steel on 30/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkTimerTask.h"
#import "ProtocolIPhoneEditWorkLogButtonClicked.h"
#import "Helpers.h"
#import "FakeProjectRepository.h"

@interface IPhoneEditWorkLogViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

- (IBAction)descriptionDidEndEditing:(id)sender;

- (IBAction)commitTouchUpInside:(id)sender;
- (IBAction)deleteTouchUpInside:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *taskCodeLabel;
@property (weak, nonatomic) IBOutlet UITextView *taskSummaryLabel;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@property (weak, nonatomic) IBOutlet UIImageView *descriptionInvalidImage;
@property (weak, nonatomic) IBOutlet UIView *timePickerView;

@property (strong, nonatomic) WorkTimerTask *currentWorkTimerTask;

@property (assign) id<ProtocolIPhoneEditWorkLogButtonClicked> delegate;

@end
