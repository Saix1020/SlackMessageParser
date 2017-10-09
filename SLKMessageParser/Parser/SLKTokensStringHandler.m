//
//  SLKTokensStringHandler.m
//  SLKMessageParser
//
//  Created by saix on 2017/9/15.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKTokensStringHandler.h"
#import "NSString+SLKMessageParser.h"

@implementation SLKTokensStringHandler

@end

@implementation SLKTokensStringHandlerHex

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* matched = [message slk_substringWithRange:[match rangeAtIndex:1]];
    NSString* matched2 = [message slk_substringWithRange:[match rangeAtIndex:2]];
    NSString* matched3 = [message slk_substringWithRange:[match rangeAtIndex:3]];

    return [NSString stringWithFormat:@"%@%@<HEX:BLOCK %@>%@", matched, matched2, matched2, matched3];

}

@end

@implementation SLKTokensStringHandlerBlankLine

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* matched = [message slk_substringWithRange:[match rangeAtIndex:1]];
    NSString* matched2 = [message slk_substringWithRange:[match rangeAtIndex:2]];
    
    return [NSString stringWithFormat:@"%@%@%@", matched, LINE_BREAK, matched2];
    
}

@end

@implementation SLKTokensStringHandlerBlankLine2

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* matched = [message slk_substringWithRange:[match rangeAtIndex:1]];
    
    return matched;
    
}

@end
