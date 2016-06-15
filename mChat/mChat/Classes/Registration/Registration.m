//
//  Registration.m
//  mChat
//
//  Created by Monu Rathor on 03/04/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "Registration.h"

@implementation Registration
@synthesize txtUserID;
@synthesize txtPassword;
@synthesize txtConfirmPassword;
@synthesize indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Registration"];
    txtPassword.secureTextEntry = YES;
    txtConfirmPassword.secureTextEntry = YES;
    [Connection sharedConnection].alertDelegate = self.view;
    [Connection sharedConnection].registrationDelegate = self;
    indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    UIView *indicatorImageView = [[UIView alloc]initWithFrame:CGRectMake(80, 80, 160, 120)];
    indicatorImageView.backgroundColor = [UIColor blackColor];
    indicatorImageView.alpha = 0.9;
    indicator.center = CGPointMake(80, 70);
    [indicatorImageView addSubview:indicator];
    UILabel *indicatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 200, 30)];
    indicatorLabel.text = @"Please wait....";
    indicatorLabel.textColor = [UIColor whiteColor];
    indicatorLabel.backgroundColor = [UIColor clearColor];
    [indicatorImageView addSubview:indicatorLabel];
    [indicatorView addSubview:indicatorImageView];
    txtUserID.delegate = self;
    txtPassword.delegate = self;
    txtConfirmPassword.delegate = self;
}

- (void)viewDidUnload
{
    [self setTxtUserID:nil];
    [self setTxtPassword:nil];
    [self setTxtConfirmPassword:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [LoginUserInfo sharedLoginUserInfo].userType = @"registration";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [LoginUserInfo sharedLoginUserInfo].userType = @"";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)stopIndicator{
    if([indicator isAnimating]){
        [indicator stopAnimating];
        [indicatorView removeFromSuperview];
    }
}

- (void)popRegistrationViewIsSuccess:(BOOL)isSuccess{
    [self stopIndicator];
    if(isSuccess){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (IBAction)clickClear:(id)sender {
    txtUserID.text = @"";
    txtPassword.text = @"";
    txtConfirmPassword.text = @"";
}

- (IBAction)clickRegistration:(id)sender {
    
    if(([[txtUserID.text componentsSeparatedByString:@" "] count]<=1) && ([[txtUserID.text componentsSeparatedByString:@"@"] count]<=1) && ([[txtUserID.text componentsSeparatedByString:@"/"] count]<=1) && (![txtUserID.text isEqualToString:@""])){
        if([txtConfirmPassword.text isEqualToString:txtPassword.text]){
            [[Connection sharedConnection]registerNewUser:txtUserID.text Password:txtPassword.text];
            [self.view endEditing:YES];
            [self.view addSubview:indicatorView];
            [indicator startAnimating];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Confirm password does not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{
        [[Connection sharedConnection]alerMessageWithTitle:@"Warning!" Message:@"Wrong user name entered. '@' and blank space are not allow in your User ID."];
    }
    
}
@end
