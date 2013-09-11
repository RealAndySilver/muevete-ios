//
//  Vibration.m
//  Muevete
//
//  Created by Andres Abril on 5/09/13.
//  Copyright (c) 2013 iAmStudio. All rights reserved.
//

#import "Vibration.h"

@implementation Vibration
+(void)vibrate{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSMutableArray* arr = [NSMutableArray array];
    [arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for 2000ms
    [arr addObject:[NSNumber numberWithInt:80]];
    //        [arr addObject:[NSNumber numberWithBool:NO]];  //stop for 1000ms
    //        [arr addObject:[NSNumber numberWithInt:1000]];
    [dict setObject:arr forKey:@"VibePattern"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
    AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
}
@end
