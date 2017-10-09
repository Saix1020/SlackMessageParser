//
//  SLKMessageToken.m
//  SLKMessageDemo
//
//  Created by saix on 2017/9/15.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKMessageToken.h"
#import "SLKMessageParser.h"
#import "NSString+SLKMessageParser.h"

@interface CommandMarkup()

@property (nonatomic, copy) NSString* label;
@property (nonatomic, copy) NSString* payload;
@property (nonatomic, copy) NSString* tokenString;

@property (nonatomic, readonly) NSString* removeMarkupRegex;
@property (nonatomic, readonly) BOOL isValid;

@end

@implementation CommandMarkup

-(instancetype)initWithToken:(NSString*)token
{
    self = [super init];
    if (self) {
        self.tokenString = token;
        self.tokenString = [self.tokenString  replaceWithRegx:self.removeMarkupRegex string:@""];
        NSArray* split = [self.tokenString componentsSeparatedByString:@"|"];
        if (split.count>0) {
            self.payload = split[0];
            if (split.count>1) {
                self.label = split[1];
            }
        }
    }
    return self;
}

-(NSString*)removeMarkupRegex
{
    return @"";
}


@end


@implementation ChannelLink

-(NSString*)removeMarkupRegex
{
    return @"<|>|#";
}

@end



@implementation UserLink

-(NSString*)removeMarkupRegex
{
    return @"<|>|@";
}

@end



@implementation Command

-(NSString*)removeMarkupRegex
{
    return @"<|>|!";
}

@end

@interface SLKMessageToken ()

@property (nonatomic, copy) NSString* token;
@property (nonatomic) SLKMessageTokenType type;

@end

@implementation SLKMessageToken



-(instancetype)initWithToken:(NSString *)token
{
    self = [super init];
    if (self) {
        self.token = token;
        self.type = [self inferType];
    }
    return self;
}


-(SLKMessageTokenType)inferType
{
    if (self.isLinkStart || self.isLinkEnd) {
        return SLKMessageTokenLINK;
    }
    if (self.isBStart || self.isBEnd) {
        return SLKMessageTokenB;
    }
    if (self.isIStart || self.isIEnd) {
        return SLKMessageTokenI;
    }
    if (self.isPreStart || self.isPreEnd) {
        return SLKMessageTokenPRE;
    }
    if (self.isCodeStart || self.isCodeEnd) {
        return SLKMessageTokenCODE;
    }
    if (self.isLineBreak) {
        return SLKMessageTokenLINE_BREAK;
    }
    if (self.isEmoji) {
        return SLKMessageTokenEMOJI;
    }
    if (self.isHexBlock) {
        return SLKMessageTokenHEX_BLOCK;
    }
    if (self.isHightlightStart || self.isHightlightEnd) {
        return SLKMessageTokenHIGHLIGHT;
    }
    if (self.isStrikeStart || self.isStrikeEnd) {
        return SLKMessageTokenSTRIKE;
    }
    if (self.isQuoteEnd || self.isQuoteStart) {
        return SLKMessageTokenQUOTE;
    }
    
    if (self.isLinkStart || self.isLinkEnd) {
        return SLKMessageTokenLINK;
    }
    
    if (self.isSpaceHead) {
        return SLKMessageTokenSPACE_HEAD;
    }
    
    if (self.isJumbomoji) {
        return SLKMessageTokenJUMBOMOJI;
    }
    
    if (self.isChannelLink) {
        return SLKMessageTokenCHANNEL;
    }
    
    if (self.isUserLink) {
        return SLKMessageTokenUSER;
    }
    
    if (self.isCommand) {
        return SLKMessageTokenCOMMAND;
    }
    
    if (self.isQuotePrefix || self.isLongQuotePrefix) {
        return SLKMessageTokenQuotePrefix;
    }
    
    return SLKMessageTokenTEXT;
}


-(BOOL)isLinkStart
{
    return [self.token hasPrefix:@"<LINK:START"];
}
-(BOOL)isLinkEnd
{
    return [self.token isEqualToString:LINK_END];
}

-(BOOL)isBEnd
{
    return [self.token isEqualToString:B_END];
}
-(BOOL)isBStart
{
    return [self.token isEqualToString:B_START];
}

-(BOOL)isIStart
{
    return [self.token isEqualToString:I_START];
}
-(BOOL)isIEnd
{
    return [self.token isEqualToString:I_END];
}

-(BOOL)isCodeStart
{
    return [self.token isEqualToString:CODE_START];
}
-(BOOL)isCodeEnd
{
    return [self.token isEqualToString:CODE_END];
}

-(BOOL)isPreStart
{
    return [self.token isEqualToString:PRE_START];
}
-(BOOL)isPreEnd
{
    return [self.token isEqualToString:PRE_END];
}

-(BOOL)isStrikeStart
{
    return [self.token isEqualToString:STRIKE_START];
}

-(BOOL)isStrikeEnd
{
    return [self.token isEqualToString:STRIKE_END];
}

-(BOOL)isQuoteStart
{
    return [self.token isEqualToString:QUOTE_START];
}

-(BOOL)isQuoteEnd
{
    return [self.token isEqualToString:QUOTE_END];
}

-(BOOL)isLongQuotePrefix
{
    return [self.token isEqualToString:LONGQUOTE_PREFIX];
}
-(BOOL)isQuotePrefix
{
    return [self.token isEqualToString:QUOTE_PREFIX];
}

-(BOOL)isLineBreak
{
    return [self.token isEqualToString:LINE_BREAK];
}

-(BOOL)isJumbomoji
{
    return [self.token hasPrefix:@"<JUMBOMOJI:COLONS"];
}

-(BOOL)isEmoji
{
    return [self.token hasPrefix:@"<EMOJI:COLONS"];
}

-(BOOL)isIsMarkup
{
    if (self.token.length == 0) {
        return NO;
    }
    return [[self.token substringToIndex:1] isEqualToString:@"<"];
}

-(BOOL)isTokenStart
{
    return [self.token hasSuffix:@":START>"] || [self.token hasPrefix:@"<LINK:START"] || [self.token hasPrefix:@"<HIGHLIGHT:START>"];
}
-(BOOL)isTokenEnd
{
    return [self.token hasSuffix:@":END>"] || [self.token hasPrefix:@"<HIGHLIGHT:END>"];
}

-(BOOL)isHexBlock
{
    return [self.token hasPrefix:@"<HEX:BLOCK"];
}

-(BOOL)isParaBreak
{
    return [self.token isEqualToString:PARA_BREAK];
}

-(BOOL)isUserLink
{
    return [self.token hasPrefix:@"<@"];
}

-(BOOL)isChannelLink
{
    return [self.token hasPrefix:@"<#"];
}

-(BOOL)isCommand
{
    return [self.token hasPrefix:@"<!"];
}

-(NSString*)paramValue
{
    NSRange range = NSMakeRange(NSNotFound, 0);
    if(self.isEmoji){
        range.location = @"<EMOJI:COLONS".length;
    }
    if(self.isJumbomoji){
        range.location = @"<JUMBOMOJI:COLONS".length;
    }
    else if (self.isLinkStart) {
        range.location = @"<LINK:START".length;
        
    }
    else if (self.isHexBlock) {
        range.location = @"<HEX:BLOCK".length;
        
    }
    
    range.length = self.token.length - range.location - 1;
    
    if (range.location != NSNotFound) {
        return [[self.token substringWithRange:range] trim];
    }
    
    return @"";
}

-(ChannelLink*)channelLink
{
    if (!self.isChannelLink) {
        return nil;
    }
    
    return [[ChannelLink alloc] initWithToken:self.token];
}
-(Command*)command
{
    if (!self.isCommand) {
        return nil;
    }
    
    return [[Command alloc] initWithToken:self.token];
}
-(UserLink*)userLink
{
    if (!self.isUserLink) {
        return nil;
    }
    return [[UserLink alloc] initWithToken:self.token];
}

-(BOOL)isSpaceHead
{
    return [self.token isEqualToString:SPACE_HARD];
}

-(NSString*)description
{
    return self.token;
}

-(NSString*)string
{
    if (self.isMarkup) {
        if (self.isLineBreak) {
            return @"\n";
        }
        else if (self.isSpaceHead) {
            return @" ";
        }
        else if (self.isParaBreak) {
            return @"\n\n";
        }
        else {
            return @"";
        }
    }
    return self.token;
}

@end

@implementation SLKMessageToken (Span)

-(NSMutableArray*)subTokens
{
    if (!_subTokens) {
        _subTokens = [NSMutableArray new];
    }
    
    return _subTokens;
}


-(void)appendStyle:(SLKMessageTokenSpanStyle)style
{
    self.spanStyle |= style;
    
    [self.subTokens enumerateObjectsUsingBlock:^(SLKMessageToken* subToken, NSUInteger idx, BOOL * _Nonnull stop) {
        [subToken appendStyle:style];
    }];
    
}


-(id)span
{
    NSMutableArray* span = [NSMutableArray new];

    if(self.type == SLKMessageTokenQUOTE){
        [span addObject:@"<quote>"];
        [self.subTokens enumerateObjectsUsingBlock:^(SLKMessageToken* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [span addObject:obj.span];
        }];
        [span addObject:@"</quote>"];

    }
    else if(self.type == SLKMessageTokenCODE){
        [span addObject:@"<code>"];

        [self.subTokens enumerateObjectsUsingBlock:^(SLKMessageToken* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [span addObject:obj.span];
        }];
        [span addObject:@"</code>"];

    }
    else if(self.type == SLKMessageTokenPRE){
        [span addObject:@"<pre>"];

        [self.subTokens enumerateObjectsUsingBlock:^(SLKMessageToken* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [span addObject:obj.span];
        }];
        [span addObject:@"</pre>"];

    }
    else {
        [span addObject:self.token];
    }
    
    return span;
}

@end

