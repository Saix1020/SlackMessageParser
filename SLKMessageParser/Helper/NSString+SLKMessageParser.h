//
//  NSString+SLKMessageParser.h
//  SLKMessageParser
//
//  Created by saix on 2017/10/9.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSLKGT @"&gt;"
#define kSLKLT @"&lt;"
#define kSLKAND @"&amp;"


@interface NSString (SLKMessageParser)

-(NSString*)replaceWithRegx:(NSString*)regx options:(NSRegularExpressionOptions)options string:(NSString*)str;
-(NSString*)replaceWithRegx:(NSString*)regx string:(NSString*)str;

-(NSString*)replace:(NSString*)str1 string:(NSString*)str;
-(NSString*)trim;
-(BOOL)match:(NSString*)regx options:(NSRegularExpressionOptions)options;
-(BOOL)match:(NSString*)regx;

-(NSString*)slk_substringWithRange:(NSRange)range;

-(NSUInteger)hex;
-(NSString*)decodeEmoji;
-(NSString*)decodeGTLTAND;



@end
