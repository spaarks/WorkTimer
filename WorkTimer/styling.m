//
//  styling.m
//  WorkTimer
//
//  Created by martin steel on 20/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import "styling.h"

@implementation styling

+(UIColor*)getTitleColor
{
    return [self getUIColorFromPList:@"TitleColor"];
}

+(void)setTableTextLabelStyling:(UILabel*)label
{
    label.textColor = [self getUIColorFromPList:@"PrimaryContentColor"];
    label.font = [styling getFont:@"FontPlain":12];
}

+(void)setTableDetailTextLabelStyling:(UILabel*)label
{
    label.textColor = [self getUIColorFromPList:@"SecondaryContentColor"];
    label.font = [styling getFont:@"FontPlain":12];
}

+(void) setHeaderLabelStyling:(UILabel*)label
{
    label.textColor = [self getUIColorFromPList:@"HeaderLabelColor"];
    label.font = [styling getFont:@"FontPlain":12];
}

+(void) setContentLabelStyling:(UILabel*)label
{
    label.textColor = [self getUIColorFromPList:@"PrimaryContentColor"];
    label.font = [styling getFont:@"FontPlain":16];
}

+(void) setSecondaryContentLabelStyling:(UILabel*)label
{
    label.textColor = [self getUIColorFromPList:@"SecondaryContentColor"];
    label.font = [styling getFont:@"FontPlain":16];
}

+(void) setContentTextViewStyling:(UITextView*)view;
{
    view.textColor = [self getUIColorFromPList:@"PrimaryContentColor"];
    view.font = [styling getFont:@"FontPlain":16];
    
    view.textContainer.lineFragmentPadding = 0;
    view.textContainerInset = UIEdgeInsetsZero;
}

+(void) setPrimaryButtonStyling:(FUIButton*)button
{
    button.buttonColor = [self getUIColorFromPList:@"ButtonColor"];
    button.cornerRadius = [styling getFloatFromStylePlist:@"ButtonRadius"];
    
    [button setTitleColor:[self getUIColorFromPList:@"ButtonTextColor"] forState:UIControlStateNormal];
    
    float textSize = [styling getFloatFromStylePlist:@"ButtonTextSize"];
    button.titleLabel.font = [styling getFont:@"FontPlain":textSize];
}

+(void) setSecondaryButtonStyling:(FUIButton*)button
{
    button.buttonColor = [styling getUIColorFromPList:@"ButtonSecondaryColor"];
    button.cornerRadius = [styling getFloatFromStylePlist:@"ButtonRadius"];
    
    [button setTitleColor:[styling getUIColorFromPList:@"ButtonSecondaryTextColor"] forState:UIControlStateNormal];
    
    float textSize = [styling getFloatFromStylePlist:@"ButtonTextSize"];
    button.titleLabel.font = [styling getFont:@"FontPlain":textSize];
}

+(void) setSecondaryBackground:(UIView*)view
{
    view.backgroundColor = [styling getUIColorFromPList:@"SecondaryBackgroundColor"];
}

+(void) setNavigationBarStyling:(UINavigationBar*)bar
{
    bar.barTintColor = [styling getUIColorFromPList:@"NavigationBarColor"];
    bar.tintColor = [styling getUIColorFromPList:@"NavigationBarTintColor"];
}

+(UIFont*)getFont:(NSString*)fontName
                 :(int)fontSize
{
    NSDictionary* styles = [self getStyles];
    return [UIFont fontWithName:[styles objectForKey: fontName] size:fontSize];
}

+(float) getFloatFromStylePlist:(NSString*)key
{
    NSDictionary* styles = [self getStyles];
    return [[styles objectForKey: key] floatValue];
}

+ (UIColor*)getUIColorFromPList:(NSString*)colorKey
{
    NSDictionary* styles = [self getStyles];
    
    NSNumber* red = [styles objectForKey:[NSString stringWithFormat:@"%@Red", colorKey]];
    NSNumber* green = [styles objectForKey:[NSString stringWithFormat:@"%@Green", colorKey]];
    NSNumber* blue = [styles objectForKey:[NSString stringWithFormat:@"%@Blue", colorKey]];
    
    return [styling colorWithR:[red floatValue] G:[green floatValue] B:[blue floatValue] A:1];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha
{
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+(NSDictionary*) getStyles
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Styles.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Styles" ofType:@"plist"];
    }
    
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    return temp;
}

@end
