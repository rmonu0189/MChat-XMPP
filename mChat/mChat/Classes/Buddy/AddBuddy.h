//
//  AddBuddy.h
//  ChattingByJabber
//
//  Created by Monu Rathor on 11/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBuddy : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *groupArray;
}
- (IBAction)clickAddBuddy:(id)sender;
- (IBAction)clickCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtBuddyId;
@property (weak, nonatomic) IBOutlet UITextField *txtNixkName;
- (IBAction)clickChatRoom:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewGroup;
- (IBAction)clickDown:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtGroupName;

@end
