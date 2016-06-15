//
//  Connection.h
//  mChat
//
//  Created by Monu Rathor on 03/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "BUddyViewController.h"
#import "ViewController.h"
#import "XMPPRoom.h"
#import "XMPPRoomCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"


@interface Connection : NSObject<XMPPStreamDelegate>
{
    XMPPStream *xmppStream;
    NSString *serverHostName,*idHostName,*conferenceHostName;
    BOOL isInternet;
    NSMutableArray *onlineBuddyList;
    NSMutableArray *onlineGroupList;
    NSMutableArray *chatBuddyMessageArray;
    NSMutableArray *fetchRoomArray;
    id buddyViewControllerDelegate;
    id viewControllerDelegate;
    XMPPRoom *xmppRoom;
    XMPPRoomCoreDataStorage *xmppRoomData;
    NSString *currentChattingBuddy,*chattingType;
    NSString *unsybscribeBuddyID;
    id chatViewDelegate;
    id alertDelegate,registrationDelegate;
    BOOL isSend;
    
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
}
@property (nonatomic, retain) id alertDelegate,registrationDelegate;
@property (nonatomic, retain) id chatViewDelegate;
@property (nonatomic, retain) XMPPRoom *xmppRoom;
@property (nonatomic, retain) NSString *unsybscribeBuddyID,*serverHostName,*chattingType,*idHostName,*conferenceHostName,*currentChattingBuddy;;
@property (nonatomic, retain) id buddyViewControllerDelegate,viewControllerDelegate;
@property (nonatomic, retain) NSMutableArray *fetchRoomArray,*onlineBuddyList,*onlineGroupList,*chatBuddyMessageArray;
@property (nonatomic, retain) XMPPStream *xmppStream;
+ (Connection*)sharedConnection;
- (void)registerNewUser:(NSString *)newUserID Password:(NSString *)password;
- (void)loginUserWithUserID:(NSString *)userID andPassword:(NSString *)password;
- (void)fetchAllBuddy;
- (void)goOffline;
- (void)createOrJoinRoomWithRoomName:(NSString *)rName NickName:(NSString *)nick;
- (void)sendFriendRequestWithFriendID:(NSString *)friendID andNickName:(NSString *)nickName;
- (void)alerMessageWithTitle:(NSString *)title Message:(NSString *)message;
- (void)sendMessage:(NSString *)msgContent ToUser:(NSString *)to;
- (void)sendGroupMessageWithGroupName:(NSString *)group Message:(NSString *)msg;
- (void)inviteUserForGroupWithUserID:(NSString *)jid message:(NSString *)message FromRoom:(NSString *)room;
- (void)deleteBuddyWithBuddyID:(NSString *)buddyID;
- (void)deleteRoomWithRoomID:(NSString *)roomID;
- (void)setServerSettingWithServerName:(NSString *)server Hostname:(NSString *)hostname Conference:(NSString *)conference;
- (NSData *)setPhotoWithID:(NSString *)jid andRoomType:(NSString *)photoRoom;
@end
