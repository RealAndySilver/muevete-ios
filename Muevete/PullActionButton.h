//
//  PullActionButton.h
//  Muevete
//
//  Created by Andres Abril on 3/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Vibration.h"
@protocol PullActionButtonDelegate
@required
-(void)actionAccepted:(int)tag;
@end

@interface PullActionButton : UIScrollView<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    UIView *button;
}
@property(nonatomic)UIColor *color;
@property(nonatomic)UIColor *hilightColor;
@property(nonatomic)UIImageView *icon;
@property(nonatomic)UILabel *label;

@property(nonatomic,retain)id<PullActionButtonDelegate>the_delegate;
@end
