//
//  ProtocolIPhoneEditWorkLogButtonClicked.h
//  WorkTimer
//
//  Created by martin steel on 15/03/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProtocolIPhoneEditWorkLogButtonClicked <NSObject>

-(void)commitClicked:(WorkTimerTask*)task;
-(void)deleteClicked;

@end
