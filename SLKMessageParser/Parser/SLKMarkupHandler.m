//
//  SLKEmojiHandler.m
//  SLKMessageParser
//
//  Created by saix on 2017/9/14.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKMarkupHandler.h"
#import "SLKMessageParser.h"
#import "SLKUrlHandler.h"
#import "NSString+SLKMessageParser.h"


@interface SLKMarkupHandler ()
@property (nonatomic, strong) NSMutableArray* emojiArray;
@property (nonatomic, copy) NSString* mode;
@property (nonatomic, strong) NSMutableArray* stringp;
@end


@implementation SLKMarkupHandler

-(instancetype)initWithPaser:(SLKMessageParser*)parser array:(NSMutableArray*)array emojiArray:(NSMutableArray*)emojiArray
{
    self = [super init];
    if (self) {
        self.array = array;
        self.emojiArray = array;
        self.mode = parser.mode;
        self.parser = parser;
    }
    
    return self;
}

-(instancetype)initWithPaser:(SLKMessageParser*)parser array:(NSMutableArray*)array emojiArray:(NSMutableArray*)emojiArray mode:(NSString*)mode
{
    self = [super init];
    if (self) {
        self.array = array;
        self.emojiArray = array;
        self.mode = mode;
        self.parser = parser;
    }
    
    return self;
}

-(instancetype)initWithPaser:(SLKMessageParser*)parser string:(NSMutableArray*)stringp array:(NSMutableArray*)array emojiArray:(NSMutableArray*)emojiArray mode:(NSString*)mode;
{
    self = [super init];
    if (self) {
        self.array = array;
        self.emojiArray = array;
        self.mode = mode;
        self.parser = parser;
        self.stringp = stringp;
    }
    
    return self;
}


-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    BOOL b = YES;
    
    if(!match){
        return nil;
    }
    
    NSString* allString = [message slk_substringWithRange:match.range];
    NSString* matchedString = [message slk_substringWithRange:[match rangeAtIndex:1]];
    NSString* substr = [matchedString slk_substringWithRange:NSMakeRange(0, 1)];
    
    NSString* placeholdStr;
    if([substr isEqualToString:@"#"]
       || [substr isEqualToString:@"@"]
       || [substr isEqualToString:@"!"]
       || [substr isEqualToString:@"%"]){
        
        placeholdStr = [self.parser placeholdStr:self.array message:allString];
    }
    else {
        NSArray* split = [matchedString componentsSeparatedByString:@"|"];
        __block NSMutableString* changedString;
        __block NSString* replace;
        [split enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx ==0 && obj.length>0){
                replace = [obj stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
                //[changedString appendString:replace];
                changedString = [replace mutableCopy];
            }
            else {
                if(obj.length>0){
                    changedString = [obj mutableCopy];
                }
            }
        }];
        NSString* trim = [changedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([trim hasPrefix:@"<"]){
            matchedString = [matchedString stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
            matchedString = [matchedString stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
            
            return [self.parser placeholdStr:self.array message:matchedString];
            
        }
        
        NSString* replace2 = [trim stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
        replace2 = [replace2 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
        if([self.mode isEqualToString:@"GROWL"]){
            // not support yet
            return placeholdStr;
        }
        else {
            placeholdStr = replace2;
            if(![self.mode isEqualToString:@"EDIT"]){
                if(![self.mode isEqualToString:@"NORMAL"]){
                    NSString* doEmoji = replace2;
                    if(![self.mode isEqualToString:@"NOMRKDWN"]){
                        return [self.parser placeholdStr:self.array message:[NSString stringWithFormat:@"<LINK:START %@>%@%@", replace, doEmoji, LINK_END]];
                    }
                }
                NSString* placeholdStr2 = replace2;
                if([self.parser isLabelUrl:replace2 and:replace]){
                    placeholdStr2 = [self.parser placeholdStr:self.array message:replace2];
                }
                NSString *s2, *s3;
                s2 = s3 = [url_rx map:placeholdStr2 handler:[[SLKMarkupHandlerWithoutEmoji alloc] initWithPaser:self.parser array:self.array]];
                if (![self.mode isEqualToString:@"NOMRKDWN"]) {
                    s3 = [self.parser doSpecials:s2 output:self.array];
                }
                NSString* doMarkup = [self.parser doMarkup:self.stringp[0] output1:[NSMutableArray new] output2:[NSMutableArray new] mode:@"EDIT"];
                if(![doMarkup isEqualToString:s3] || ![jumbomoji_rx match:doMarkup]){
                    b = NO;
                }
                NSString* doEmoji = [self.parser doEmoji:s3 output:self.emojiArray flag:b];
                
                return [self.parser placeholdStr:self.array message:[NSString stringWithFormat:@"<LINK:START %@>%@%@", replace, doEmoji,LINK_END]];
            }
            
        }
    }
    
    return placeholdStr;
    
}



@end



@implementation SLKMarkupHandlerWithoutEmoji

-(NSString*)handle:(NSString *)message match:(NSTextCheckingResult *)match
{
    NSString* allString = [message substringWithRange:match.range];
    return [self.parser placeholdStr:self.array message:allString];
}

@end
