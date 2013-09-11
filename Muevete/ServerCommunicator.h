//
//  ServerCommunicator.h
//  WebConsumer
//
//  Created by Andres Abril on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAmCoder.h"
#import "FileSaver.h"
@interface ServerCommunicator : NSObject<UITextFieldDelegate,NSXMLParserDelegate,UIApplicationDelegate>{
    id caller;
    int tag;
    //----- Direcciones del WebService-----
	NSMutableData *webData;
	NSMutableString *soapResults;
    NSURLConnection *theConnection;

    //----- XML Parsing
	NSXMLParser *xmlParser;
	BOOL elementFound;
    
    NSDictionary *dictionary;
    NSMutableArray *objectDic;
    
}
@property int tag;
@property (nonatomic,retain) id caller;
@property (nonatomic,retain) NSMutableArray *objectDic;
@property(nonatomic,retain)NSDictionary *dictionary;
@property(nonatomic,retain)NSString *methodName;

-(void)callServerWithGETMethod:(NSString*)method andParameter:(NSString*)parameter;
-(void)callServerWithPOSTMethod:(NSString*)method andParameter:(NSString*)parameter httpMethod:(NSString*)httpMethod;

@end
