//
//  BUddyViewController.h
//  mChat
//
//  Created by Monu Rathor on 04/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPRoster.h"

@interface BUddyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIBarButtonItem *buttonAddUser;
    UIBarButtonItem *buttonLogout;
}
@property (nonatomic, retain) XMPPRoster *xmppRoster;
@property (weak, nonatomic) IBOutlet UITableView *tableViewBuddy;
- (void)reloadBuddyList;
@end
