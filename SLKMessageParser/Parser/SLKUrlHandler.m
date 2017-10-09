//
//  SLKUrlHander.m
//  SLKMessageParser
//
//  Created by saix on 2017/9/15.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKUrlHandler.h"

@interface SLKUrlHandler ()
@property (nonatomic, strong) NSMutableArray* stringp;

@end
@implementation SLKUrlHandler
-(instancetype)initWithPaser:(SLKMessageParser *)parser string:(NSMutableArray *)stringp
{
    self = [super init];
    if (self) {
        self.array = nil;
        self.parser = parser;
        self.stringp = stringp;
    }
    
    return self;
}

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* allString = [message substringWithRange:match.range];
    self.stringp[0] = allString;
    return allString;
}

@end

