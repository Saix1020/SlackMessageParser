//
//  SLKEmojiHandler.m
//  SLKMessageParser
//
//  Created by saix on 2017/9/15.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKEmojiHandler.h"

@interface SLKEmojiHandler()
@property (nonatomic, copy) NSString* token;

@end


@implementation SLKEmojiHandler
-(instancetype)initWithPaser:(SLKMessageParser*)parser token:(NSString*)token array:(NSMutableArray*)array
{
    self = [super initWithPaser:parser array:array];
    if (self) {
        self.token = token;
    }
    
    return self;
}

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* allString = [message substringWithRange:match.range];

    return [self.parser placeholdStr:self.array message:[NSString stringWithFormat:@"<%@:COLONS %@>", self.token, allString]];
}

@end
