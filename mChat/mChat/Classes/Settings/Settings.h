//
//  Settings.h
//  mChat
//
//  Created by Mac22 on 09/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtServer;
@property (weak, nonatomic) IBOutlet UITextField *txtHostname;
@property (weak, nonatomic) IBOutlet UITextField *txtConference;
- (IBAction)clickSave:(id)sender;
- (IBAction)clickClear:(id)sender;

@end
