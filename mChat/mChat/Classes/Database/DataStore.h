//
//  DataStore.h
//  ChattingByJabber
//
//  Created by Monu Rathor on 21/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject
- (void)AddGroupRoomWithName:(NSString *)groupName UserName:(NSString *)userName;
- (NSMutableArray *)showAllGroupRoomWithUserName:(NSString *)user;
- (void)deleteRoomWithGroupID:(NSString *)groupName;
- (NSMutableArray *)showSettings;
- (void)saveSettingWithServer:(NSString *)server idHostName:(NSString *)isHostName andConferenceHostname:(NSString *)conference;
@end
