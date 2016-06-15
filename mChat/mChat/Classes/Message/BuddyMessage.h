//
//  BuddyMessage.h
//  mChat
//
//  Created by Mac22 on 05/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuddyMessage : NSObject
{
    NSString *buddyID;
    NSString *buddyName;
    NSString *messageType;//conference or single
    NSMutableArray *messageArray;
}
@property (nonatomic, retain) NSString *buddyID;
@property (nonatomic, retain) NSString *buddyName;
@property (nonatomic, retain) NSString *messageType;
@property (nonatomic, retain) NSMutableArray *messageArray;
@end
