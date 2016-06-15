//
//  Connection.m
//  mChat
//
//  Created by Monu Rathor on 03/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "Connection.h"
#import "BuddyInfo.h"
#import "Message.h"
#import "BuddyMessage.h"
#import "ChatView.h"
#import "AlertViewController.h"
#import "DataStore.h"
#import "GroupRoomData.h"
#import "Registration.h"

@implementation Connection
@synthesize xmppStream,conferenceHostName;
@synthesize onlineBuddyList,onlineGroupList;
@synthesize serverHostName,idHostName;
@synthesize xmppRoom,chatBuddyMessageArray;
@synthesize currentChattingBuddy;
@synthesize chatViewDelegate;
@synthesize alertDelegate;
@synthesize fetchRoomArray;
@synthesize chattingType;
@synthesize registrationDelegate;
@synthesize unsybscribeBuddyID;
@synthesize buddyViewControllerDelegate,viewControllerDelegate;
static Connection* _sharedStoreUser;

#pragma mark - For singleton method

+ (id)alloc {
	@synchronized([Connection class]) {
		NSAssert(_sharedStoreUser == nil, @"Attempted to allocate a second instance of singleton class MusicPlayers.");
		_sharedStoreUser = [super alloc];
		return _sharedStoreUser;
	}
	return nil;
    
}

+ (Connection*)sharedConnection
{
	@synchronized(self) {
		
        if (_sharedStoreUser == nil) {
            [[self alloc] init];
        }
    }
    return _sharedStoreUser;
}

- (void)setServerSettingWithServerName:(NSString *)server Hostname:(NSString *)hostname Conference:(NSString *)conference{
    serverHostName = server;
    idHostName = hostname;
    conferenceHostName = conference;
    //NSLog(@"Server setting:%@\n%@\n%@",server,hostname,conference);
}

- (void)loginUserInfoInitializeWithUserID:(NSString *)userID andPassword:(NSString *)password andUserWantTo:(NSString *)userWant{
    //This method is useful for initialize all user starting info
    [[LoginUserInfo sharedLoginUserInfo]setUserID:[NSString stringWithFormat:@"%@%@",userID,idHostName]];
    [[LoginUserInfo sharedLoginUserInfo]setPassword:password];
    [[LoginUserInfo sharedLoginUserInfo]setUserType:userWant];
}

- (void)setupStream{
    onlineBuddyList = [[NSMutableArray alloc]init];
    onlineGroupList = [[NSMutableArray alloc]init];
    chatBuddyMessageArray = [[NSMutableArray alloc]init];
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    [xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
}

- (void)goOnline
{
    [viewControllerDelegate stopIndicator];
	XMPPPresence *presence = [XMPPPresence presence];
	[xmppStream sendElement:presence];
    [self setupStream];
    [viewControllerDelegate showBuddyViewController];
    DataStore *db = [[DataStore alloc]init];
    fetchRoomArray = [db showAllGroupRoomWithUserName:[LoginUserInfo sharedLoginUserInfo].userID];
    for(int i=0; i<[fetchRoomArray count];i++){
        GroupRoomData *groupRoomData = [[GroupRoomData alloc]init];
        groupRoomData = [fetchRoomArray objectAtIndex:i];
        [self createOrJoinRoomWithRoomName:[[groupRoomData.groupName componentsSeparatedByString:@"@"] objectAtIndex:0] NickName:[[groupRoomData.userName componentsSeparatedByString:@"@"] objectAtIndex:0]];
    }
    [self fetchAllBuddy];
}

- (void)goOffline
{
    [viewControllerDelegate stopIndicator];
	NSLog(@"\n**********************\n%@: Method:goOffline....................\n**********************\n", [self class]);
	[xmppStream sendElement:[XMPPPresence presenceWithType:@"unavailable"]];
    [xmppStream sendElement:[XMPPPresence presence]];
    [xmppStream disconnect];
    [self loginUserInfoInitializeWithUserID:@"" andPassword:@"" andUserWantTo:@""];
}

- (void)streamInitializeWithUserID:(NSString *)userID{
    
    isInternet = NO;
    if(xmppStream == nil){
        xmppStream = [[XMPPStream alloc] init];
    }
    if(![serverHostName isEqualToString:@""]){
        xmppStream.hostName = serverHostName;
        xmppStream.hostPort = 5222;
    }
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppStream.myJID = [XMPPJID jidWithString:userID];
	NSError *error = nil;
	if (![xmppStream connect:&error])
	{
		NSLog(@"\n**********************\n%@: Error connecting: %@\n**********************\n", [self class], error);
	}
}


#pragma mark - Registration or login user user

- (void)registerNewUser:(NSString *)newUserID Password:(NSString *)password{
    [self loginUserInfoInitializeWithUserID:newUserID andPassword:password andUserWantTo:@"registration"];
    [self streamInitializeWithUserID:[LoginUserInfo sharedLoginUserInfo].userID];
}

- (void)loginUserWithUserID:(NSString *)userID andPassword:(NSString *)password{
    [self loginUserInfoInitializeWithUserID:userID andPassword:password andUserWantTo:@"login"];
    [self streamInitializeWithUserID:[LoginUserInfo sharedLoginUserInfo].userID];
}

- (void)sendFriendRequestWithFriendID:(NSString *)friendID andNickName:(NSString *)nickName{
    NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
    if(nickName){
        [presence addAttributeWithName:@"name" stringValue:nickName];
    }
    [presence addAttributeWithName:@"type" stringValue:@"subscribe"];
    [presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",friendID,idHostName]];
    [presence addAttributeWithName:@"from" stringValue:[LoginUserInfo sharedLoginUserInfo].userID];
    [xmppStream sendElement:presence];
    
}

- (void)acceptFriendRequestWithFriendID:(NSString *)friendID{
    NSLog(@"Friend ID:%@",friendID);
    NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
    [presence addAttributeWithName:@"type" stringValue:@"subscribe"];
    [presence addAttributeWithName:@"to" stringValue:friendID];
    [presence addAttributeWithName:@"from" stringValue:[LoginUserInfo sharedLoginUserInfo].userID];
    [xmppStream sendElement:presence];
    NSXMLElement *presence1 = [NSXMLElement elementWithName:@"presence"];
    [presence1 addAttributeWithName:@"type" stringValue:@"subscribed"];
    [presence1 addAttributeWithName:@"to" stringValue:friendID];
    [presence1 addAttributeWithName:@"from" stringValue:[LoginUserInfo sharedLoginUserInfo].userID];
    [xmppStream sendElement:presence1];
}

- (void)createOrJoinRoomWithRoomName:(NSString *)rName NickName:(NSString *)nick {
    
    NSString *roomName = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@%@",rName,conferenceHostName]];
    if(xmppRoomData == nil){
        xmppRoomData = [[XMPPRoomCoreDataStorage alloc]init];
    }
    xmppRoom = [[XMPPRoom alloc]initWithRoomStorage:xmppRoomData  jid:[XMPPJID jidWithString:roomName]];
    [xmppRoom activate:xmppStream];
    [xmppRoom joinRoomUsingNickname:[[[LoginUserInfo sharedLoginUserInfo].userID componentsSeparatedByString:@"@"] objectAtIndex:0] history:nil];
    [xmppRoom addDelegate:self  delegateQueue:dispatch_get_main_queue()];
}

- (void)fetchAllBuddy{
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [xmppStream sendElement:iq];
}

- (void)sendMessage:(NSString *)msgContent ToUser:(NSString *)to{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:msgContent];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",to,idHostName]];
    [message addChild:body];
    [xmppStream sendElement:message];
}

- (void)sendGroupMessageWithGroupName:(NSString *)group Message:(NSString *)msg{
    isSend = YES;
    NSXMLElement *body = [NSXMLElement elementWithName:@"body" stringValue:msg];
    XMPPMessage *message = [XMPPMessage message];
    [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",group,conferenceHostName]];
    [message addAttributeWithName:@"type" stringValue:@"groupchat"];
    [message addChild:body];
    [xmppStream sendElement:message];
}

- (void)inviteUserForGroupWithUserID:(NSString *)jid message:(NSString *)message FromRoom:(NSString *)room {
    //NSLog(@"[XMPPMRCreateRoom] inviteUser:");
    NSXMLElement *invite = [NSXMLElement elementWithName:@"invite"];
    [invite addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",jid,idHostName]];
    if ([message length] > 0)
    {
        [invite addChild:[NSXMLElement elementWithName:@"reason" stringValue:message]];
    }
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCUserNamespace];
    [x addChild:invite];
    XMPPMessage *message1 = [XMPPMessage message];
    XMPPJID *roomJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",room,conferenceHostName]];
    [message1 addAttributeWithName:@"to" stringValue:[roomJID full]];
    [message1 addChild:x];
    [xmppStream sendElement:message1];
}

- (void)acceptRoomWithRoomName:(NSString *)roomNameInvite{
    if ([xmppStream isConnected]) {
        NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
        [presence addAttributeWithName:@"from" stringValue:[[xmppStream myJID]full]];
        [presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@/%@",roomNameInvite,conferenceHostName,[[[LoginUserInfo sharedLoginUserInfo].userID componentsSeparatedByString:@"@"]objectAtIndex:0]]];
        [xmppStream sendElement:presence];
    }
}

- (void)deleteBuddyWithBuddyID:(NSString *)buddyID{
    NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
    [presence addAttributeWithName:@"type" stringValue:@"unsubscribe"];
    [presence addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",buddyID,idHostName]];
    [presence addAttributeWithName:@"from" stringValue:[LoginUserInfo sharedLoginUserInfo].userID];
    [xmppStream sendElement:presence];
    
    NSXMLElement *presence1 = [NSXMLElement elementWithName:@"presence"];
    [presence1 addAttributeWithName:@"type" stringValue:@"unsubscribed"];
    [presence1 addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@%@",buddyID,idHostName]];
    [presence1 addAttributeWithName:@"from" stringValue:[LoginUserInfo sharedLoginUserInfo].userID];
    [xmppStream sendElement:presence1];
}

- (void)deleteRoomWithRoomID:(NSString *)roomID{
    XMPPPresence *presence = [XMPPPresence presence];
    NSString *myRoomJID = [NSString stringWithFormat:@"%@%@/%@",roomID,conferenceHostName,[[@"" componentsSeparatedByString:@"@"]objectAtIndex:0]];
    [presence addAttributeWithName:@"to" stringValue:myRoomJID];
    [presence addAttributeWithName:@"type" stringValue:@"unavailable"];
    [xmppStream sendElement:presence];
}

- (void)rejectFriendRequestWithFriendID:(NSString *)friendID{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unsubscribed" to:[[XMPPJID jidWithString:friendID] bareJID]];
	[xmppStream sendElement:presence];
}

- (NSData *)setPhotoWithID:(NSString *)jid andRoomType:(NSString *)photoRoom{
    NSString *host = [[NSString alloc]init];
    if([photoRoom isEqualToString:@"group"]){
        host = conferenceHostName;
    }
    else{
        host = idHostName;
    }
    NSData *photoData = [xmppvCardAvatarModule photoDataForJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",jid,host]]];
    return photoData;
}

#pragma mark - XMPPDelegate method

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    isInternet = YES;
	NSError *error = nil;
	if([[[LoginUserInfo sharedLoginUserInfo]userType] isEqualToString:@"login"]){
        if (![xmppStream authenticateWithPassword:[[LoginUserInfo sharedLoginUserInfo]password] error:&error])
        {
            NSLog(@"\n**********************\n%@: Error authenticating: %@\n**********************\n", [self class], error);
        }
    }
    else{
        if (![xmppStream registerWithPassword:[[LoginUserInfo sharedLoginUserInfo]password] error:&error])
        {
            NSLog(@"\n**********************\n%@: Error authenticating: %@\n**********************\n", [self class], error);
        }
    }
}


- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if([[LoginUserInfo sharedLoginUserInfo].userType isEqualToString:@"registration"]){
        [registrationDelegate popRegistrationViewIsSuccess:NO];
    }
    if([[LoginUserInfo sharedLoginUserInfo].userType isEqualToString:@"login"]){
        [viewControllerDelegate stopIndicator];
    }
    NSLog(@"Disconnecting Error:%@",error);
    xmppStream = nil;
    if(isInternet == NO){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Application not connect to server. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    [self alerMessageWithTitle:@"Congratulation!" Message:[NSString stringWithFormat:@"Your registration is success.\nYour User ID:%@",[[[[LoginUserInfo sharedLoginUserInfo]userID] componentsSeparatedByString:@"@"]objectAtIndex:0]]];
    NSLog(@"Register success");
    [registrationDelegate popRegistrationViewIsSuccess:YES];
    [self goOffline];
    xmppStream = nil;
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    [self goOffline];
    [self alerMessageWithTitle:@"Warning!" Message:@"Registration not successfully. please check user id or password or try after 5 minuts."];
    NSLog(@"Error:%@",error);
    [registrationDelegate popRegistrationViewIsSuccess:NO];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	NSLog(@"\n**********************\n%@: Method:xmppStreamDidAuthenticate....................\n**********************\n", [self class]);
    [self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    [self goOffline];
    [self alerMessageWithTitle:@"Warning!" Message:@"User ID or Password incorrect."];
    NSLog(@"\n**********************\n%@: Method:didNotAuthenticate....................\n**********************\n", [self class]);
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    NSLog(@"xmppRoomDidJoin Sender myRoomJID:%@",[NSString stringWithFormat:@"%@",[[sender myRoomJID] user]]);
    NSString *roomName = [[NSString alloc] init];
    BOOL isAvailable = NO;
    GroupRoomData *groupRoomData = [[GroupRoomData alloc]init];
    for(int i=0;i<[fetchRoomArray count];i++){
        groupRoomData = [fetchRoomArray objectAtIndex:i];
        roomName = [[groupRoomData.groupName componentsSeparatedByString:@"@"] objectAtIndex:0];
        if([roomName isEqualToString:[[sender myRoomJID] user]]){
            isAvailable = YES;
        }
    }
    if(isAvailable==NO){
        DataStore *db = [[DataStore alloc] init];
        [db AddGroupRoomWithName:[NSString stringWithFormat:@"%@%@",[[sender myRoomJID]user],conferenceHostName] UserName:[LoginUserInfo sharedLoginUserInfo].userID];
    }
}

#pragma mark - xmppStream delegate method for receive or send message or presence

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	NSString *msgContent = [[message elementForName:@"body"] stringValue];
	NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *buddyName = [[from componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSLog(@"content:%@\n**********************\nMessage: %@ \nFrom:%@\n**********************\n",message,msgContent,from);
    NSString *buddyType = [[[[from componentsSeparatedByString:@"@"] lastObject] componentsSeparatedByString:@"."] objectAtIndex:0];
    Message *buddyMessage = [[Message alloc]init];
    buddyMessage.messageBody = msgContent;
    buddyMessage.from = from;
    if([buddyType isEqualToString:@"conference"]){
        NSLog(@"Conference");
        BOOL isRoom = NO;
        for(int i=0;i<[onlineGroupList count];i++){
            if([buddyName isEqualToString:[onlineGroupList objectAtIndex:i]]){
                isRoom = YES;
            }
        }
        NSString *groupMessageSender = [[from componentsSeparatedByString:@"/"] lastObject];
        if([groupMessageSender isEqualToString:[[[LoginUserInfo sharedLoginUserInfo].userID componentsSeparatedByString:@"@"]objectAtIndex:0]]){
            if(isSend==YES){
                isSend = NO;
                return;
            }
            buddyMessage.type = @"send";
        }
        else if((isRoom==NO) && [msgContent rangeOfString:@"Hi!, Please join me."].length != 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"*** Invite Group ***" message:[NSString stringWithFormat:@"Hi! Please join me in group %@",buddyName] delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:@"Reject", nil];
            [alert show];
            return;
        }
        else{
            buddyMessage.messageBody = [groupMessageSender stringByAppendingFormat:@": %@",buddyMessage.messageBody];
            buddyMessage.type = @"receive";
        }
    }
    else{
        NSLog(@"\nchatBuddyMessageArray Count:%d",[chatBuddyMessageArray count]);
        NSLog(@"normal");
        buddyMessage.type = @"receive";
        
    }
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    BuddyMessage *buddyMsg1 = [[BuddyMessage alloc]init];
    BOOL isMatch = NO;
    for(int i=0;i<[chatBuddyMessageArray count];i++){
        buddyMsg1 = [chatBuddyMessageArray objectAtIndex:i];
        if([buddyMsg1.buddyName isEqualToString:buddyName]){
            NSLog(@"@@@@@@@@@buddyMsg.buddyName:%@    buddyName:%@",buddyMsg1.buddyName,buddyName);
            temp = buddyMsg1.messageArray;
            [chatBuddyMessageArray removeObject:buddyMsg1];
            isMatch = YES;
        }
    }
    NSLog(@"\nchatBuddyMessageArray Count:%d",[chatBuddyMessageArray count]);
    BuddyMessage *buddyMsg = [[BuddyMessage alloc]init];
    buddyMsg.buddyName = buddyName;
    buddyMsg.buddyID = from;
    buddyMsg.messageType = @"normal";
    if(isMatch == NO){
        buddyMsg.messageArray = [[NSMutableArray alloc]init];
    }
    else{
        buddyMsg.messageArray = temp;
    }
    [buddyMsg.messageArray addObject:buddyMessage];
    [chatBuddyMessageArray addObject:buddyMsg];
    if([currentChattingBuddy isEqualToString:buddyName]){
        [chatViewDelegate setIsGroup:YES];
        [chatViewDelegate receiveMessageWithMessage:buddyMessage.messageBody];
    }
    else{
        NSString *alertMessage = [NSString stringWithFormat:@"%@:- %@",buddyName,msgContent];
        AlertViewController *alert = [[AlertViewController alloc]init];
        [alert displayAlertViewControllerWithDelegate:alertDelegate Message:alertMessage];
    }
}



- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSString *buddyPresence = [presence type];  //available/unavailable/subscribe
    NSString *buddyID = [[[presence fromStr] componentsSeparatedByString:@"/"] objectAtIndex:0];
	NSString *myUserName = [[sender myJID] user];
	NSString *buddyName = [[presence from] user];
    NSString *buddyType = [[[[buddyID componentsSeparatedByString:@"@"] lastObject] componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSLog(@"PresenceContent:%@\n***********\nbuddyPresence:%@\nbuddyID:%@\nmyUserName:%@\nbuddyName:%@\nbuddyType:%@",presence,buddyPresence,buddyID,myUserName,buddyName,buddyType);
    
    if(![myUserName isEqualToString:buddyName]){
        if([buddyType isEqualToString:@"conference"]){
            NSString *offlineBuddy = [[[presence fromStr] componentsSeparatedByString:@"/"] lastObject];
            if([buddyPresence isEqualToString:@"available"]){
                
                if(![offlineBuddy isEqualToString:[[[LoginUserInfo sharedLoginUserInfo].userID componentsSeparatedByString:@"@"] objectAtIndex:0]]){
                    NSString *alertMessage = [NSString stringWithFormat:@"%@ is now online\nFrom Group: %@",offlineBuddy,buddyName];
                    AlertViewController *alert = [[AlertViewController alloc]init];
                    [alert displayAlertViewControllerWithDelegate:alertDelegate Message:alertMessage];
                    [onlineBuddyList removeObject:buddyName];
                }
                
                BOOL isMatch = NO;
                for(int i=0;i<[onlineGroupList count];i++){
                    if([[onlineGroupList objectAtIndex:i] isEqualToString:buddyName]){
                        isMatch = YES;
                    }
                }
                if(isMatch == NO){
                    [onlineGroupList addObject:buddyName];
                }
            }
            else if([buddyPresence isEqualToString:@"unavailable"]){
                
                NSString *alertMessage = [NSString stringWithFormat:@"%@ is now offline\nFrom Group: %@",offlineBuddy,buddyName];
                AlertViewController *alert = [[AlertViewController alloc]init];
                [alert displayAlertViewControllerWithDelegate:alertDelegate Message:alertMessage];
                [onlineBuddyList removeObject:buddyName];
            }
        }
        else{
            if([buddyPresence isEqualToString:@"available"]){
                BOOL isMatch = NO;
                for(int i=0;i<[onlineBuddyList count];i++){
                    if([[onlineBuddyList objectAtIndex:i] isEqualToString:buddyName]){
                        isMatch = YES;
                    }
                }
                if(isMatch == NO){
                    [onlineBuddyList addObject:buddyName];
                }
            }
            else if([buddyPresence isEqualToString:@"subscribe"]){
                NSString *alertMessage = [NSString stringWithFormat:@"%@ wants to chat with you.",buddyName];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"*** Invite Friend ***" message:alertMessage delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:@"Reject", nil];
                [alert show];
            }
            else if([buddyPresence isEqualToString:@"unsubscribed"]){
                unsybscribeBuddyID = buddyID;
            }
            else if([buddyPresence isEqualToString:@"unavailable"]){
                if([unsybscribeBuddyID isEqualToString:buddyID]){
                    unsybscribeBuddyID = @"";
                }
                else{
//                    NSString *alertMessage = [NSString stringWithFormat:@"%@ is now offline",buddyName];
//                    AlertViewController *alert = [[AlertViewController alloc]init];
//                    [alert displayAlertViewControllerWithDelegate:alertDelegate Message:alertMessage];
                }
                [onlineBuddyList removeObject:buddyName];
            }
            else if([buddyPresence isEqualToString:@"subscribed"]){
                
            }
        }
    }
    [buddyViewControllerDelegate reloadBuddyList];
}

#pragma mark - Alert message method

- (void)alerMessageWithTitle:(NSString *)title Message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView.title isEqualToString:@"*** Invite Friend ***"]){
        NSString *invitID = [NSString stringWithFormat:@"%@%@",[[alertView.message componentsSeparatedByString:@" "] objectAtIndex:0],idHostName];
        if(buttonIndex==0){
            [self acceptFriendRequestWithFriendID:invitID];
            NSLog(@"\n\n%%%%%%Invite ID:%@\n%%%%%%\n\n",invitID);
        }
        else{
            [self rejectFriendRequestWithFriendID:invitID];
            NSLog(@"Reject");
        }
    }
    else if([alertView.title isEqualToString:@"*** Invite Group ***"]){
        if(buttonIndex == 0){
            NSString *roomName = [[alertView.message componentsSeparatedByString:@" "]lastObject];
            [self acceptRoomWithRoomName:roomName];
            DataStore *db = [[DataStore alloc] init];
            [db AddGroupRoomWithName:[NSString stringWithFormat:@"%@%@",roomName,conferenceHostName] UserName:[LoginUserInfo sharedLoginUserInfo].userID];
        }
        else{
            
        }
    }
}

@end
