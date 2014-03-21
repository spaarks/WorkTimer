//
//  UIHelpers.h
//  WorkTimer
//
//  Created by martin steel on 21/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelpers : NSObject

+ (void) animateTextField : (UIView*) container
                          : (UITextField*) textField
                          : (BOOL) up
                          : (int) distance
                          : (float) duration;
@end
