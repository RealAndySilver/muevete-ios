//
//  CustomCell.m
//  Muevete
//
//  Created by Andres Abril on 4/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "CustomCell.h"
#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
#define kRedColor [UIColor colorWithRed:250.0/255 green:88.0/255 blue:88.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]
@implementation CustomCell
@synthesize timeLabel,dateLabel,metersLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        metersLabel=[[UILabel alloc]initWithFrame:CGRectMake(216, 53, 90, 30)];
        [metersLabel setBackgroundColor:[UIColor darkGrayColor]];
        metersLabel.layer.cornerRadius=0;
        metersLabel.textAlignment=NSTextAlignmentCenter;
        metersLabel.textColor=[UIColor whiteColor];
        metersLabel.font=[UIFont boldSystemFontOfSize:25];
        metersLabel.adjustsFontSizeToFitWidth=YES;

        [self addSubview:metersLabel];
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 50)];
        timeLabel.adjustsFontSizeToFitWidth=YES;
        timeLabel.textAlignment=NSTextAlignmentCenter;
        timeLabel.font=[UIFont boldSystemFontOfSize:48];
        timeLabel.textColor=[UIColor whiteColor];
        [timeLabel setBackgroundColor:kRedColor];
        timeLabel.layer.cornerRadius=10;
        [self addSubview:timeLabel];
        
        dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 45, 200, 40)];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        dateLabel.adjustsFontSizeToFitWidth=YES;
        dateLabel.textColor=[UIColor darkGrayColor];
        dateLabel.font=[UIFont boldSystemFontOfSize:30];
        [self addSubview:dateLabel];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelectionStyle:UITableViewCellSelectionStyleGray];
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
