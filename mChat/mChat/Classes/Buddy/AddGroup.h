//
//  AddGroup.h
//  ChattingByJabber
//
//  Created by Monu Rathor on 18/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGroup : UIViewController<UITextFieldDelegate>
- (IBAction)clickAddGroup:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtGroupName;
- (IBAction)clickClear:(id)sender;

@end
