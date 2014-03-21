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

@end
