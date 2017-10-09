//
//  SLKTokenArrayHandler.m
//  SLKMessageParser
//
//  Created by saix on 2017/9/15.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKTokenArrayHandler.h"

@interface SLKTokenArrayHandler ()

@property (nonatomic, strong) NSMutableArray* startPosp;
@property (nonatomic, strong) NSMutableArray* beforep;
@property (nonatomic, copy) NSString* string;
@end

@implementation SLKTokenArrayHandler

-(instancetype)initWithPaser:(SLKMessageParser *)parser startPos:(NSMutableArray*)startPosp string:(NSString*)newString before:(NSMutableArray*)beforep array:(NSMutableArray *)array
{
    self = [super init];
    if (self) {
        self.array = array;
        self.parser = parser;
        self.startPosp = startPosp;
        self.string = newString;
        self.beforep = beforep;
    }
    
    return self;
}

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* allString = [message substringWithRange:match.range];
    NSInteger matchedPos = match.range.location;
    NSInteger startPos = [self.startPosp[0] integerValue];
    if(matchedPos != startPos){
        self.beforep[0] = [self.string substringWithRange:NSMakeRange(startPos, matchedPos-startPos)];
        [self.array addObject:self.beforep[0]];
        
    }
    [self.array addObject:allString];
    self.startPosp[0] = @(match.range.length + match.range.location);
    return allString;
}

@end
