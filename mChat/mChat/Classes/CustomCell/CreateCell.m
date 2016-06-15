//
//  CreateCell.m
//  ChattingByJabber
//
//  Created by Monu Rathor on 08/03/13.
//  Copyright (c) 2013 HT. All rights reserved.
//

#import "CreateCell.h"

@implementation CreateCell
@synthesize lblDate,lblName,lblDescription,imageView;

       
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
        {
            self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
            if (self) {
                // Initialization code
                
                lblName=[[UILabel alloc] initWithFrame:CGRectMake(55,10.0,180.0,25.0)];
                lblName.font=[UIFont fontWithName:@"Arial" size:23.0];
                lblDescription=[[UILabel alloc] initWithFrame:CGRectMake(200.0,40.0,200.0,20.0)];
                lblDescription.font=[UIFont fontWithName:@"Times New Roman" size:18.0];
                lblDate=[[UILabel alloc] initWithFrame:CGRectMake(200.0,70.0,100.0,20.0)];
                imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
                [self.contentView addSubview:lblName];
                //[self.contentView addSubview:lblDescription];
                //[self.contentView addSubview:lblDate];
                [self.contentView addSubview:imageView];
            }
            return self;

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
