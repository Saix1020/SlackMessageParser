//
//  SLKSpecialsHandler.m
//  SLKMessageParser
//
//  Created by saix on 2017/9/15.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKSpecialsHandler.h"


@implementation SLKSpecialsHandler



@end

@implementation SLKSpecialsHandlerPre

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{    
    NSString* matched = [message slk_substringWithRange:match.range];
    NSString* matched2 = [message slk_substringWithRange:[match rangeAtIndex:1]];
    NSString* matched3 = [message slk_substringWithRange:[match rangeAtIndex:2]];
    
    if(matched3.length == 0 || [matched3 trim].length== 0){
        return matched;
    }
    NSString* subStr = matched3;
    if([matched3 hasPrefix:@"\n"]){
        subStr = [matched3 substringFromIndex:1];
    }

    NSString* replacedStr = [self.parser encodeForPre:subStr];
    replacedStr = [self.parser removeSmartQuotes:subStr];
    replacedStr = [self.parser placeholdStr:self.array message:replacedStr];
    
    return [NSString stringWithFormat:@"%@%@%@%@", matched2, PRE_START, replacedStr, PRE_END];
}


@end

@implementation SLKSpecialsHandlerCode

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* matched = [message slk_substringWithRange:match.range];
    NSString* matched2 = [message slk_substringWithRange:[match rangeAtIndex:1]];
    NSString* matched3 = [message slk_substringWithRange:[match rangeAtIndex:2]];
    
    if(matched3.length == 0
       || [matched3 hasPrefix:@"`"]
       || [matched3 hasSuffix:@"`"]
       || [matched3 match:@"<PRE:START>"]
       || [matched3 match:@"<PRE:END>"]){
        return matched;
    }
    NSString* subStr = matched3;
    NSString* replacedStr = [self.parser removeSmartQuotes:subStr];
    replacedStr = [replacedStr replace:TBT_PLACEHOLDER string:@"```"];
    replacedStr = [self.parser placeholdStr:self.array message:replacedStr];
    
    return [NSString stringWithFormat:@"%@%@%@%@", matched2, CODE_START, replacedStr, CODE_END];
}


@end

@implementation SLKSpecialsHandlerItalics

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* matched = [message slk_substringWithRange:match.range];
    NSString* matched2 = [message slk_substringWithRange:[match rangeAtIndex:1]];
    NSString* matched3 = [message slk_substringWithRange:[match rangeAtIndex:2]];
    
    if(matched3.length == 0
       || [matched3 hasPrefix:@"_"]
       || [matched3 hasSuffix:@"_"]
       || ![matched3 match:@"[^_*`~]"]){
        return matched;
    }
    NSString* replacedStr = [self.parser doSpecials:matched3 output:self.array];
    
    
    return [NSString stringWithFormat:@"%@%@%@%@", matched2, I_START, replacedStr, I_END];
}


@end

@implementation SLKSpecialsHandlerBold

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* matched = [message slk_substringWithRange:match.range];
    NSString* matched2 = [message slk_substringWithRange:[match rangeAtIndex:1]];
    NSString* matched3 = [message slk_substringWithRange:[match rangeAtIndex:2]];
    
    if(matched3.length == 0
       || [matched3 hasPrefix:@"*"]
       || [matched3 hasSuffix:@"*"]
       || ([matched3 hasPrefix:@" "] &&[matched3 hasSuffix:@" "])
       || ![matched3 match:@"[^_*`~]"]){
        return matched;
    }
    NSString* replacedStr = [self.parser doSpecials:matched3 output:self.array];
    
    
    return [NSString stringWithFormat:@"%@%@%@%@", matched2, B_START, replacedStr, B_END];
}


@end

@implementation SLKSpecialsHandlerStrike

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* matched = [message slk_substringWithRange:match.range];
    NSString* matched2 = [message slk_substringWithRange:[match rangeAtIndex:1]];
    NSString* matched3 = [message slk_substringWithRange:[match rangeAtIndex:2]];
    
    if(matched3.length == 0
       || [matched3 hasPrefix:@"~"]
       || [matched3 hasSuffix:@"~"]
       || ([matched3 hasPrefix:@" "] &&[matched3 hasSuffix:@" "])
       || ![matched3 match:@"[^_*`~]"]){
        return matched;
    }
    NSString* replacedStr = [self.parser doSpecials:matched3 output:self.array];
    
    
    return [NSString stringWithFormat:@"%@%@%@%@", matched2, STRIKE_START, replacedStr, STRIKE_END];
}


@end
@implementation SLKSpecialsHandlerLongQuote

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* matched = [message slk_substringWithRange:match.range];
    NSString* matched2 = [message slk_substringWithRange:[match rangeAtIndex:1]];
    NSString* matched3 = [message slk_substringWithRange:[match rangeAtIndex:2]];
    
    if([matched isEqualToString:@"&gt;&gt;&gt;"]){
        return @"&gt;&gt;&gt;";
    }
    
    SLKRegx* regx = [[SLKRegx alloc] initWithRegxStr:@"^([\\s]*)(&gt;)*" options:0];
    
    NSString* replacedStr = [regx map:matched3 handler:[[SLKSpecialsHandlerQuoteX alloc] initWithPaser:self.parser array:nil]];
    return [NSString stringWithFormat:@"%@%@%@%@%@", matched2, QUOTE_START, LONGQUOTE_PREFIX, replacedStr, QUOTE_END];
}


@end



@implementation SLKSpecialsHandlerQuoteX

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* matched = [message slk_substringWithRange:match.range];
    NSString* matched2 = [message slk_substringWithRange:[match rangeAtIndex:2]];
    
    if(matched2.length != 0) {
        return matched;
    }
    return @"";
}


@end

@implementation SLKSpecialsHandlerQuote

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* matched = [message substringWithRange:match.range];
    NSString* matched2 = [message substringWithRange:[match rangeAtIndex:1]];
    NSString* matched3 = [message substringWithRange:[match rangeAtIndex:2]];
    
    if([matched isEqualToString:@"&gt;"]){
        return @"&gt;";
    }
        
    NSString* replacedStr = [matched3 replaceWithRegx:@"\n&gt;" string:[NSString stringWithFormat:@"\n%@", QUOTE_PREFIX]];
    return [NSString stringWithFormat:@"%@%@%@%@%@", matched2, QUOTE_START, QUOTE_PREFIX, replacedStr, QUOTE_END];
}


@end


