//
//  TutorialView.m
//  Muevete
//
//  Created by Andres Abril on 12/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "TutorialView.h"
#define kGreenColor [UIColor colorWithRed:64.0/255 green:174.0/255 blue:126.0/255 alpha:1]
#define kRedColor [UIColor colorWithRed:250.0/255 green:88.0/255 blue:88.0/255 alpha:1]
#define kYellowColor [UIColor colorWithRed:191.0/255 green:184.0/255 blue:50.0/255 alpha:1]
#define kBlueColor [UIColor colorWithRed:59.0/255 green:89.0/255 blue:152.0/255 alpha:1]
@implementation TutorialView
@synthesize textView,titleLabel,superTitleLabel,mainImageView,topLogo,bottomImageView,bottomLine;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 400, 150, 30)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont fontWithName:@"Helvetica" size:20];
        titleLabel.textColor=[UIColor darkGrayColor];
        
        
        superTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,
                                                                 titleLabel.frame.origin.y+titleLabel.frame.size.height,
                                                                 250,
                                                                 40)];
        superTitleLabel.backgroundColor=[UIColor clearColor];
        superTitleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:40];
        superTitleLabel.textColor=kRedColor;
        
        bottomImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, self.frame.size.height-110, 130, 60)];
        [self addSubview:bottomImageView];
        
        mainImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 50, self.frame.size.width-40, 290)];
        mainImageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-40);
        [mainImageView setClipsToBounds:YES];
        [self addSubview:mainImageView];
        
        [self addSubview:titleLabel];
        [self addSubview:superTitleLabel];
        
        textView=[[UITextView alloc]initWithFrame:CGRectMake(15, self.frame.size.height-110, self.frame.size.width-30, 100)];
        textView.backgroundColor=[UIColor clearColor];
        textView.textColor=[UIColor grayColor];
        textView.textAlignment=NSTextAlignmentJustified;
        [textView setEditable:NO];
        [self addSubview:textView];
        
        bottomLine=[[UILabel alloc]initWithFrame:CGRectMake(20, self.frame.size.height-25, 270, 20)];
        bottomLine.backgroundColor=kRedColor;
        bottomLine.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        bottomLine.textColor=[UIColor whiteColor];
        bottomLine.textAlignment=NSTextAlignmentCenter;
        bottomLine.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-15);
        bottomLine.layer.cornerRadius=10;
        [self addSubview:bottomLine];
        
    }
    return self;
}

@end
