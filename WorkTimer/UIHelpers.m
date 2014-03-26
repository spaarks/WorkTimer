//
//  UIHelpers.m
//  WorkTimer
//
//  Created by martin steel on 21/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "UIHelpers.h"

@implementation UIHelpers

+ (void) animateTextField : (UIView*) container
                          : (UITextField*) textField
                          : (BOOL) up
                          : (int) distance
                          : (float) duration
{

    int movement = (up ? -distance : distance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: duration];
    container.frame = CGRectOffset(container.frame, 0, movement);
    [UIView commitAnimations];
}

+ (void)gotoParentByIndex :(UIViewController*) currentViewController
                          :(int) index
{
    NSInteger currentIndex = [currentViewController.navigationController.viewControllers indexOfObject:currentViewController];
    if( currentIndex-index >= 0 )
        [currentViewController.navigationController popToViewController:[currentViewController.navigationController.viewControllers objectAtIndex:currentIndex-index] animated:YES];
}

+ (void)goToParentController:(UIViewController*) currentViewController
{
    [UIHelpers gotoParentByIndex:currentViewController:1];
}

+ (void)goToGrandParentController:(UIViewController*) currentViewController
{
    [UIHelpers gotoParentByIndex:currentViewController:2];
}

@end
