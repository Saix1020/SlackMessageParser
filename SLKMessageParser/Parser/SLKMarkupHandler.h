//
//  SLKEmojiHandler.h
//  SLKMessageParser
//
//  Created by saix on 2017/9/14.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKTokenHandler.h"

@class SLKMessageParser;


@interface SLKMarkupHandler : SLKTokenHandler

-(instancetype)initWithPaser:(SLKMessageParser*)parser array:(NSMutableArray*)array emojiArray:(NSMutableArray*)emojiArray;
-(instancetype)initWithPaser:(SLKMessageParser*)parser array:(NSMutableArray*)array emojiArray:(NSMutableArray*)emojiArray mode:(NSString*)mode;
-(instancetype)initWithPaser:(SLKMessageParser*)parser string:(NSMutableArray*)stringp array:(NSMutableArray*)array emojiArray:(NSMutableArray*)emojiArray mode:(NSString*)mode;

@end

@interface SLKMarkupHandlerWithoutEmoji : SLKTokenHandler


@end
