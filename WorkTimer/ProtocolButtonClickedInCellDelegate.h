//
//  ButtonClickedInCellProtocol.h
//  WorkTimer
//
//  Created by martin steel on 23/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ButtonGridCell.h"

@class ButtonGridCell;

@protocol ProtocolButtonClickedInCellDelegate

-(void)startClicked:(BOOL)isPause
                   :(ButtonGridCell*)cell;
-(void)stopClicked:(ButtonGridCell*)cell;

@end