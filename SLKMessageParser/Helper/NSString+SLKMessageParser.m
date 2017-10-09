//
//  NSString+SLKMessageParser.m
//  SLKMessageParser
//
//  Created by saix on 2017/10/9.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "NSString+SLKMessageParser.h"
#import "SLKEmojiMap.h"

@implementation NSString (SLKMessageParser)

-(NSString*)decodeGTLTAND
{
    NSString* result = self;
    result = [self stringByReplacingOccurrencesOfString:kSLKGT withString:@">"];
    result = [result stringByReplacingOccurrencesOfString:kSLKLT withString:@"<"];
    result = [result stringByReplacingOccurrencesOfString:kSLKAND withString:@"&"];
    
    return result;
}

-(NSString*)slk_substringWithRange:(NSRange)range
{
    if(range.location != NSNotFound && range.location+range.length<=self.length){
        return [self substringWithRange:range];
    }
    return nil;
}

-(NSString*)replaceWithRegx:(NSString*)regx options:(NSRegularExpressionOptions)options string:(NSString*)str
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regx options:0 error:nil];
    return [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:str];
    
}

-(NSString*)replaceWithRegx:(NSString *)regx string:(NSString *)str
{
    return [self replaceWithRegx:regx options:0 string:str];
}

-(NSString*)replace:(NSString*)str1 string:(NSString*)str
{
    return [self stringByReplacingOccurrencesOfString:str1 withString:str];
}

-(NSString*)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


-(BOOL)match:(NSString*)regx options:(NSRegularExpressionOptions)options
{
    
    if(self.length == 0){
        return NO;
    }
    NSRegularExpression *regxx = [NSRegularExpression regularExpressionWithPattern:regx options:options error:nil];
    
    NSArray *matches = [regxx matchesInString:self
                                      options:0
                                        range:NSMakeRange(0, self.length)];
    
    return matches.count>0;
    
}
-(BOOL)match:(NSString*)regx
{
    return [self match:regx options:0];
}

-(NSUInteger)hex
{
    unsigned int hex;
    NSString* hexString = [self copy];
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        //
    }
    else {
        hexString = [NSString stringWithFormat:@"0x%@", self];
    }
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&hex];
    
    return hex;
}

-(NSString*)decodeEmoji
{
    
    if ([self hasPrefix:@":"] && [self hasSuffix:@":"]) {
        NSArray* splits = [self componentsSeparatedByString:@":"];
        NSString* emojiString = splits[1];
        NSString* emoji = [[SLKEmojiMap SLKEmojiMap] objectForKey:emojiString];
        if(emoji.length == 0) {
            return @"";
        }
        
        NSArray* unicodes = [emoji componentsSeparatedByString:@"_"];
        NSMutableData* emojiData = [NSMutableData new];
        [unicodes enumerateObjectsUsingBlock:^(NSString* unicodeString, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* hexString = [NSString stringWithFormat:@"0x%@", unicodeString];
            NSScanner *scanner=[NSScanner scannerWithString:hexString];
            unsigned int temp;
            [scanner scanHexInt:&temp];
            [emojiData appendBytes:&temp length:sizeof(temp)];
            
        }];
        
        return  [[NSString alloc] initWithData:emojiData encoding:NSUTF32LittleEndianStringEncoding];
    }
    else {
        return @"";
    }
    
    
    
}

-(NSMutableAttributedString*)attributedString
{
    return [[NSMutableAttributedString alloc] initWithString:self];
}


@end
