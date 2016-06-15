//
//  AlertViewController.h
//  ChattingByJabber
//
//  Created by Monu Rathor on 22/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertViewController : UIViewController
{
    UIView *alertView;
    id delegate;
    
    UITextView *textView;
}
@property (nonatomic,retain) UITextView *textView;
@property (nonatomic, retain) UIView *alertView;
@property (nonatomic, retain) id delegate;
- (void)displayAlertViewControllerWithDelegate:(id)del Message:(NSString *)msg;
@end