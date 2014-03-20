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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [styling setPrimaryButtonStyling:self.doneButton];
    [styling setPrimaryButtonStyling:self.cancelButton];
    
    [styling setHeaderLabelStyling:self.userNameLabel];
    [styling setHeaderLabelStyling:self.passwordLabel];
    [styling setHeaderLabelStyling:self.serverLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(BOOL)validateAllFields
{
    [self checkUserName];
    [self checkPassword];
    [self checkServerPath];
    
    return [_currentSettings isUserNameValid] &&
    [_currentSettings isPasswordValid] &&
    [_currentSettings isServerValid];
}

- (IBAction)doneTouchUpInside:(id)sender
{
    if(![self validateAllFields])
        return;
    
    _currentSettings.parserType = XMLParserTypeJIRAParser;
    
    [Repository saveSettings:_currentSettings];
    
    UIViewController *vc = [self presentingViewController];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTouchUpInside:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
