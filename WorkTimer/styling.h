//
//  styling.h
//  WorkTimer
//
//  Created by martin steel on 20/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUIButton.h"
#import "UIFont+FlatUI.h"

@interface styling : NSObject

+(void) setPrimaryButtonStyling:(FUIButton*)button;
+(void) setSecondaryButtonStyling:(FUIButton*)button;
+(UIFont*)getFont:(NSString*)fontName
                 :(int)fontSize;
+(void) setHeaderLabelStyling:(UILabel*)label;
+(void) setContentLabelStyling:(UILabel*)label;
+(void) setContentTextViewStyling:(UITextView*)view;
+(void) setSecondaryBackground:(UIView*)view;
+(void) setNavigationBarStyling:(UINavigationBar*)bar;
+(void) setSecondaryContentLabelStyling:(UILabel*)label;
+(void)setTableTextLabelStyling:(UILabel*)label;
+(void)setTableDetailTextLabelStyling:(UILabel*)label;

@end
