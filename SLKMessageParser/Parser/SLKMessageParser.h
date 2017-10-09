//
//  SLKMessageParser.h
//  SLKMessageParser
//
//  Created by saix on 2017/9/14.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLKRegx;

extern NSString* B_END;
extern NSString* B_START;
extern NSString* CODE_END;
extern NSString* CODE_START;
extern NSString* EMOJI_COLONS;
extern NSString* HEX_BLOCK;
extern NSString* I_END;
extern NSString* I_START;
extern NSString* JUMBOMOJI_COLONS;
extern NSString* LINE_BREAK;
extern NSString* LINK_END;
extern NSString* LINK_START;
extern NSString* LONGQUOTE_PREFIX;
extern NSString* PARA_BREAK;
extern NSString* PRE_END;
extern NSString* PRE_START;
extern NSString* QUOTE_END;
extern NSString* QUOTE_PREFIX;
extern NSString* QUOTE_START;
extern NSString* SPACE_HARD;
extern NSString* STRIKE_END;
extern NSString* STRIKE_START;
extern NSString* TBT_PLACEHOLDER;

extern SLKRegx* bold_rx;
extern SLKRegx* code_rx;
extern SLKRegx* emoji_rx;
extern SLKRegx* i_rx;
extern SLKRegx* jumbomoji_rx;
extern SLKRegx* long_quote_rx;
extern SLKRegx* pre_rx;
extern SLKRegx* quote_rx;
extern SLKRegx* strike_rx;
extern SLKRegx* url_rx;



@interface SLKMessageParser : NSObject

@property (nonatomic, readonly) NSString* mode;
-(NSArray*)getTokensArray:(NSString*)message mode:(NSString*)modex flag:(NSDictionary*)flags;
-(NSString*)placeholdStr:(NSMutableArray*)array message:(NSString*)message;
-(BOOL)isLabelUrl:(NSString*)str1 and:(NSString*)str2;
-(NSString*)doSpecials:(NSString*)string output:(NSMutableArray*)array;
-(NSString*)doMarkup:(NSString*)string output1:(NSMutableArray*)array1 output2:(NSMutableArray*)emojiArray mode:(NSString*)mode;
-(NSString*)doEmoji:(NSString*)string output:(NSMutableArray*)array flag:(BOOL)f;
-(NSString*)removeSmartQuotes:(NSString*)string;
-(NSString*)encodeForPre:(NSString*)string;
@end
