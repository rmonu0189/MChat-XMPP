//
//  Registration.h
//  mChat
//
//  Created by Monu Rathor on 03/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Registration : UIViewController<UITextFieldDelegate>{
    UIActivityIndicatorView *indicator;
    UIView *indicatorView;
}
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (retain, nonatomic) IBOutlet UITextField *txtUserID;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)clickRegistration:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
- (void)popRegistrationViewIsSuccess:(BOOL)isSuccess;
- (IBAction)clickClear:(id)sender;
- (void)stopIndicator;
@end
