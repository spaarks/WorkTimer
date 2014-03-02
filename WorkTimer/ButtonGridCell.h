//
//  ButtonGridCell.h
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockView.h"
#import "FakeProjectRepository.h"
#import "ProtocolButtonClickedInCellDelegate.h"

@interface ButtonGridCell : UICollectionViewCell<NSCoding>

@property (weak, nonatomic) IBOutlet UILabel *taskKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskSummaryLabel;
@property (weak, nonatomic) IBOutlet ClockView *clockView;
@property BOOL alreadyStarted;
@property (nonatomic,strong) NSString *comment;

@property (weak, nonatomic) IBOutlet UIButton *startOrPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (assign) id<ProtocolButtonClickedInCellDelegate> delegate;

-(void)tapCell:(BOOL) selected;

- (IBAction)startPauseTouchUpInside:(id)sender;
- (IBAction)stopTouchUpInside:(id)sender;

@end
