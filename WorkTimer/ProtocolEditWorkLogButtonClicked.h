//
//  ProtocolEditWorkLogButtonClicked.h
//  WorkTimer
//
//  Created by martin steel on 01/02/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ButtonGridCell.h"

@protocol ProtocolEditWorkLogButtonClickedDelegate <NSObject>

-(void)commitClicked:(WorkTimerTask*)task
                    :(ButtonGridCell*)currentCell;
-(void)cancelClicked:(ButtonGridCell*)currentCell;
-(void)deleteClicked:(WorkTimerTask*)task
                    :(ButtonGridCell*)currentCell;

@end
