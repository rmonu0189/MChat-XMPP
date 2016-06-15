//
//  BuddyInfo.h
//  mChat
//
//  Created by Monu Rathor on 04/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuddyInfo : NSObject
{
    NSString *buddyName;
    NSString *buddyID;
    NSString *buddyPresence;
    NSString *buddyType; //buddy or group
    NSMutableArray *buddyMessage;
}
@property (nonatomic, retain) NSString *buddyName,*buddyID,*buddyPresence,*buddyType;
@property (nonatomic, retain) NSMutableArray *buddyMessage;
@end
