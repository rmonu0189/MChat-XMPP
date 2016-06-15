//
//  ViewController.h
//  mChat
//
//  Created by Monu Rathor on 03/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>{
    UIActivityIndicatorView *indicator;
    UIView *indicatorView;
    UIBarButtonItem *barButtonSetting;
}
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
- (IBAction)clickRegistration:(id)sender;
- (IBAction)clickLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtUserID;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (void)showBuddyViewController;
- (void)stopIndicator;
@end
