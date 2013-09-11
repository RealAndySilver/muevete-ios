//
//  FacebookShareViewController.h
//  Muevete
//
//  Created by Andres Abril on 7/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PullActionButton.h"

@interface FacebookShareViewController : UIViewController<PullActionButtonDelegate>{
    IBOutlet UITextView *textView;
}
@property(nonatomic, retain)NSDictionary *postParams;
@end
