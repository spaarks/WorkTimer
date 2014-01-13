//
//  WorkTimerTask.h
//  WorkTimer
//
//  Created by martin steel on 13/01/2014.
//  Copyright (c) 2014 martin steel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkTimerTask : NSObject

//12229
@property (nonatomic, copy) NSString *taskID;

//BMSCCHANGE-33
@property (nonatomic, copy) NSString *taskKey;

//Meeting Internal
@property (nonatomic, copy) NSString *taskSummary;

@end
