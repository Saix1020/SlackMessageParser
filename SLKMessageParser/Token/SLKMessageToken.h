//
//  SLKMessageToken.h
//  SLKMessageDemo
//
//  Created by saix on 2017/9/15.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SLKMessageTokenB,
    SLKMessageTokenCODE,
    SLKMessageTokenEMOJI,
    SLKMessageTokenJUMBOMOJI,
    SLKMessageTokenHEX_BLOCK,
    SLKMessageTokenHIGHLIGHT,
    SLKMessageTokenI,
    SLKMessageTokenLINE_BREAK,
    SLKMessageTokenLINK,
    SLKMessageTokenPRE,
    SLKMessageTokenQUOTE,
    SLKMessageTokenSTRIKE,
    SLKMessageTokenSPACE_HEAD,
    SLKMessageTokenCHANNEL,
    SLKMessageTokenUSER,
    SLKMessageTokenCOMMAND,
    SLKMessageTokenQuotePrefix,
    SLKMessageTokenTEXT
} SLKMessageTokenType;

typedef enum : NSUInteger {
    kSLKMessageTokenSpanB = 1 << 0,
    kSLKMessageTokenSpanI = 1 << 1,
    kSLKMessageTokenSpanSTRIKE = 1 << 2,
    kSLKMessageTokenSpanCODE = 1 << 3,
} SLKMessageTokenSpanStyle;
/*
typedef enum : NSUInteger {
    kSLKMessageTokenSpanQuote,
    kSLKMessageTokenSpanCode,
    kSLKMessageTokenSpanPre,
    kSLKMessageTokenSpanText,
} SLKMessageTokenSpanType;
*/

@class UserLink;
@class Command;
@class ChannelLink;

@interface CommandMarkup : NSObject

@property (nonatomic, readonly) NSString* label;
@property (nonatomic, readonly) NSString* payload;
@property (nonatomic, readonly) NSString* tokenString;

-(instancetype)initWithToken:(NSString*)token;

@end

@interface UserLink : CommandMarkup

@end

@interface Command : CommandMarkup

@end


@interface ChannelLink : CommandMarkup


@end


@interface SLKMessageToken : NSObject
@property (nonatomic, readonly) NSString* token;
@property (nonatomic, readonly) SLKMessageTokenType type;


@property (nonatomic, readonly) BOOL isLinkStart;
@property (nonatomic, readonly) BOOL isLinkEnd;
@property (nonatomic, readonly) BOOL isBStart;
@property (nonatomic, readonly) BOOL isBEnd;
@property (nonatomic, readonly) BOOL isIStart;
@property (nonatomic, readonly) BOOL isIEnd;
@property (nonatomic, readonly) BOOL isPreStart;
@property (nonatomic, readonly) BOOL isPreEnd;
@property (nonatomic, readonly) BOOL isCodeStart;
@property (nonatomic, readonly) BOOL isCodeEnd;
@property (nonatomic, readonly) BOOL isStrikeStart;
@property (nonatomic, readonly) BOOL isStrikeEnd;

@property (nonatomic, readonly) BOOL isQuoteStart;
@property (nonatomic, readonly) BOOL isQuoteEnd;
@property (nonatomic, readonly) BOOL isQuotePrefix;
@property (nonatomic, readonly) BOOL isLongQuotePrefix;


@property (nonatomic, readonly) BOOL isLineBreak;
@property (nonatomic, readonly) BOOL isEmoji;
@property (nonatomic, readonly) BOOL isJumbomoji;
@property (nonatomic, readonly) BOOL isHightlightStart;
@property (nonatomic, readonly) BOOL isHightlightEnd;

@property (nonatomic, readonly) BOOL isTokenStart;
@property (nonatomic, readonly) BOOL isTokenEnd;

@property (nonatomic, readonly) BOOL isMarkup;
@property (nonatomic, readonly) BOOL isUserLink;

@property (nonatomic, readonly) BOOL isChannelLink;
@property (nonatomic, readonly) BOOL isCommand;

@property (nonatomic, readonly) BOOL isParaBreak;
@property (nonatomic, readonly) BOOL isHexBlock;


@property (nonatomic, readonly) BOOL isSpaceHead;

@property (nonatomic, readonly) NSString* paramValue;
@property (nonatomic, readonly) ChannelLink* channelLink;
@property (nonatomic, readonly) Command* command;
@property (nonatomic, readonly) UserLink* userLink;

//
@property (nonatomic, strong) NSMutableArray* subTokens;
@property (nonatomic, strong) SLKMessageToken* startToken;

@property (nonatomic) SLKMessageTokenSpanStyle spanStyle;



-(instancetype)initWithToken:(NSString*)token;
-(NSString*)string;
@end

@interface SLKMessageToken (Span)

-(void)appendStyle:(SLKMessageTokenSpanStyle)style;
-(id)span;

@end




