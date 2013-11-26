//
//  ServerCommunicator.m
//  WebConsumer
//
//  Created by Andres Abril on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerCommunicator.h"
#define ENDPOINT @"http://10.0.1.7:5000/api_1.0/"
//#define ENDPOINT @"http://muevete.aws.af.cm/api_1.0/"

@implementation ServerCommunicator
@synthesize dictionary,tag,caller,objectDic,methodName;
-(id)init {
    self = [super init];
    if (self) {
        tag = 0;
        caller = nil;
        methodName = nil;
        webData = nil;
        theConnection = nil;
    }
    return self;
}
-(void)callServerWithGETMethod:(NSString*)method andParameter:(NSString*)parameter{
    parameter=[parameter stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    parameter=[parameter stringByExpandingTildeInPath];
    methodName=method;
    method=[NSString stringWithFormat:@"%@/%@",method,parameter];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ENDPOINT,method]];
    
    NSMutableURLRequest *theRequest = [self getHeaderForUrl:url];

	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	dictionary = [[NSDictionary alloc]init];
	if(theConnection) {
		webData = [NSMutableData data];
        NSLog(@"theConnection %@",theRequest.allHTTPHeaderFields);

	}
	else {
		NSLog(@"theConnection is NULL");
	}
}

-(void)callServerWithPOSTMethod:(NSString *)method andParameter:(NSString *)parameter httpMethod:(NSString *)httpMethod{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ENDPOINT,method]];
	NSMutableURLRequest *theRequest = [self getHeaderForUrl:url];

    [theRequest setHTTPMethod:httpMethod];
    //parameter=[IAmCoder base64String:parameter];
    NSData *data=[NSData dataWithBytes:[parameter UTF8String] length:[parameter length]];
    [theRequest setHTTPBody: data];
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	dictionary = [[NSDictionary alloc]init];
	if(theConnection) {
		webData = [NSMutableData data];
        NSLog(@"theConnection %@",[NSString stringWithUTF8String:[theRequest.HTTPBody bytes]]);
	}
	else {
		NSLog(@"theConnection is NULL");
	}
}
#pragma mark - http header
-(NSMutableURLRequest*)getHeaderForUrl:(NSURL*)url{
    NSString *key=@"lop+2dzuioa/000mojijiaop";
    NSString *time=[IAmCoder dateString];
    NSString *encoded=[NSString stringWithFormat:@"%@",[IAmCoder sha256:[NSString stringWithFormat:@"%@%@",key,time]]];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [theRequest setValue:[NSString stringWithFormat:@"%@",[IAmCoder base64String:key]] forHTTPHeaderField:@"C99-RSA"];
    [theRequest setValue:[NSString stringWithFormat:@"%@",[IAmCoder base64String:time]] forHTTPHeaderField:@"SSL"];
    [theRequest setValue:encoded forHTTPHeaderField:@"token"];
    NSLog(@"Header %@\nTime %@",theRequest.allHTTPHeaderFields,time);
    return theRequest;
}
#pragma mark NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[webData setLength:0];
	NSLog(@"didReceiveresponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[webData appendData:data];
	NSLog(@"didReceiveData");
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"didFailWithError %@",error);
    if ([caller respondsToSelector:@selector(receivedDataFromServerWithError:)]) {
        [caller performSelector:@selector(receivedDataFromServerWithError:) withObject:self];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
        dictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    //NSLog(@"res: %@",res);
    
    int statusCode;
    if (![dictionary isKindOfClass:[NSArray class]]) {
        if ([dictionary objectForKey:@"status"]) {
            statusCode=[[dictionary objectForKey:@"status"] intValue];
            if (statusCode == 0) {
                NSLog(@"Status here %i",statusCode);
                [self connection:nil didFailWithError:nil];
                return;
            }
        }
    }
    
    if ([caller respondsToSelector:@selector(receivedDataFromServer:)]) {
        [caller performSelector:@selector(receivedDataFromServer:) withObject:self];
    }
}

@end
