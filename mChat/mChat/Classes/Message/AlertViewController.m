//
//  AlertViewController.m
//  ChattingByJabber
//
//  Created by Monu Rathor on 22/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "AlertViewController.h"

@implementation AlertViewController
@synthesize alertView,delegate;
@synthesize textView;

- (void)displayAlertViewControllerWithDelegate:(id)del Message:(NSString *)msg{
    delegate = del;
    alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    alertView.backgroundColor = [UIColor lightGrayColor];
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    textView.font = [UIFont fontWithName:@"Times New Roman" size:15.0];
    textView.text = msg;
    textView.backgroundColor = [UIColor clearColor];
    [alertView addSubview:textView];
    
    [delegate addSubview:alertView];
    alertView.center = CGPointMake(160, -25);
    [UIView beginAnimations:msg context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    alertView.center = CGPointMake(160, 25);
    [UIView commitAnimations];    
}

-(void) animationDidStop:(NSString*) animationID finished:(NSNumber*) finished context:(void*) context{
    if([animationID isEqualToString:textView.text]){
        [UIView beginAnimations:@"Finish" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:3.0];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        alertView.center = CGPointMake(160, -25);
        [UIView commitAnimations];
    }
    if([animationID isEqualToString:@"Finish"]){
        alertView.hidden = YES;
        alertView = nil;
    }
}

@end
