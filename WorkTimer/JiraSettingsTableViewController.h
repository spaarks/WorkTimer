//
//  settingsViewController.h
//  WorkTimer
//
//  Created by martin steel on 20/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "LocalRepository.h"
#import "TaskParser.h"
#import "FUIButton.h"
#import "styling.h"
#import "UIHelpers.h"

@interface JiraSettingsTableViewController : UITableViewController<UITextFieldDelegate>

- (IBAction)userNameDidEndEditing:(id)sender;
- (IBAction)passwordDidEndEditing:(id)sender;
- (IBAction)serverDidEndEditing:(id)sender;
- (IBAction)tempoTokenDidEndEditing:(id)sender;

- (IBAction)doneTouchUpInside:(id)sender;
- (IBAction)cancelTouchUpInside:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempoTokenLabel;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *serverTextField;
@property (weak, nonatomic) IBOutlet UITextField *tempoTokenTextField;

@property (weak, nonatomic) IBOutlet FUIButton *doneButton;
@property (weak, nonatomic) IBOutlet FUIButton *cancelButton;

@property (nonatomic, strong) Settings* currentSettings;

@property (weak, nonatomic) IBOutlet UIImageView *userNameInvalidImage;
@property (weak, nonatomic) IBOutlet UIImageView *passwordInvalidImage;
@property (weak, nonatomic) IBOutlet UIImageView *serverInvalidImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempoTokenInvalidImage;
@end

