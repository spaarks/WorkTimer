//
//  settingsViewController.m
//  WorkTimer
//
//  Created by martin steel on 20/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "JiraSettingsTableViewController.h"

@implementation JiraSettingsTableViewController

@synthesize currentSettings = _currentSettings;

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        if(!_currentSettings)
            _currentSettings = [[Settings alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Settings";
    
    UIColor* titleColor = [styling getTitleColor];
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: titleColor}];
    
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [styling setPrimaryButtonStyling:self.doneButton];
    [styling setPrimaryButtonStyling:self.cancelButton];
    
    [styling setHeaderLabelStyling:self.userNameLabel];
    [styling setHeaderLabelStyling:self.passwordLabel];
    [styling setHeaderLabelStyling:self.serverLabel];
    [styling setHeaderLabelStyling:self.tempoTokenLabel];
    
    [self.userNameTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
    [self.serverTextField setDelegate:self];
    [self.tempoTokenTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma textfield methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)userNameDidEndEditing:(id)sender
{
    [self checkUserName];
}

-(void)checkUserName
{
    _currentSettings.userName = self.userNameTextField.text;
    self.userNameInvalidImage.hidden = [_currentSettings isUserNameValid];
}

- (IBAction)passwordDidEndEditing:(id)sender
{
    [self checkPassword];
}

-(void)checkPassword
{
    _currentSettings.password = self.passwordTextField.text;
    self.passwordInvalidImage.hidden = [_currentSettings isPasswordValid];
}

- (IBAction)serverDidEndEditing:(id)sender
{
    [self checkServerPath];
}

-(void)checkServerPath
{
    _currentSettings.serverPath = self.serverTextField.text;
    self.serverInvalidImage.hidden = [_currentSettings isServerValid];
}

- (IBAction)tempoTokenDidEndEditing:(id)sender
{
    [self checkTempoToken];
}

- (void)showInvalidIcon:(UITextField *)field
{
    if (![_currentSettings isTempoTokenValid])
    {
        field.rightViewMode = UITextFieldViewModeAlways;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        imageView.image = [UIImage imageNamed:@"Error.ico"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        field.rightView = imageView;
    }
    else
    {
        field.rightViewMode = UITextFieldViewModeNever;
        field.rightView = nil;
    }
}

-(void)checkTempoToken
{
    _currentSettings.tempoToken = self.tempoTokenTextField.text;

    UITextField* field = self.tempoTokenTextField;
    
    [self showInvalidIcon:field];
}

-(BOOL)validateAllFields
{
    [self checkUserName];
    [self checkPassword];
    [self checkServerPath];
    [self checkTempoToken];
    
    return [_currentSettings isUserNameValid] &&
    [_currentSettings isPasswordValid] &&
    [_currentSettings isServerValid] &&
    [_currentSettings isTempoTokenValid];
}

- (IBAction)doneTouchUpInside:(id)sender
{
    if(![self validateAllFields])
    {
        [self showWarningAlert];
        return;
    }
    
    _currentSettings.parserType = XMLParserTypeJIRAParser;
    
    [SettingsRepository saveSettings:_currentSettings];
    
    [UIHelpers goToGrandParentController:self];
}

- (IBAction)cancelTouchUpInside:(id)sender
{
    [UIHelpers goToParentController:self];
}

-(void)showWarningAlert
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid value for all fields" delegate:self cancelButtonTitle:@"Hide" otherButtonTitles:nil];
    [alert show];
}

@end
