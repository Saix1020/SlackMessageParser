//
//  SLKMessageParser.m
//  SLKMessageParser
//
//  Created by saix on 2017/9/14.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKMessageParser.h"
#import "SLKRegx.h"
#import "SLKUrlHandler.h"
#import "SLKMarkupHandler.h"
#import "SLKEmojiHandler.h"
#import "SLKTokensStringHandler.h"
#import "SLKTokenArrayHandler.h"
#import "SLKSpecialsHandler.h"
#import "NSString+SLKMessageParser.h"

NSString* B_START = @"<B:START>";
NSString* B_END = @"<B:END>";
NSString* PRE_START = @"<PRE:START>";
NSString* PRE_END = @"<PRE:END>";
NSString* CODE_START = @"<CODE:START>";
NSString* CODE_END = @"<CODE:END>";
NSString* I_START = @"<I:START>";
NSString* I_END = @"<I:END>";
NSString* STRIKE_START = @"<STRIKE:START>";
NSString* STRIKE_END = @"<STRIKE:END>";
NSString* QUOTE_START = @"<QUOTE:START>";
NSString* QUOTE_PREFIX = @"<QUOTE:PREFIX>";
NSString* LONGQUOTE_PREFIX = @"<LONGQUOTE:PREFIX>";
NSString* QUOTE_END = @"<QUOTE:END>";
NSString* LINK_START = @"<LINK:START $>";
NSString* LINK_END = @"<LINK:END>";
NSString* LINE_BREAK = @"<LINE:BREAK>";
NSString* PARA_BREAK = @"<PARA:BREAK>";
NSString* SPACE_HARD = @"<SPACE:HARD>";
NSString* EMOJI_COLONS = @"<EMOJI:COLONS $>";
NSString* JUMBOMOJI_COLONS = @"<JUMBOMOJI:COLONS $>";
NSString* HEX_BLOCK = @"<HEX:BLOCK $>";
NSString* TBT_PLACEHOLDER = @"<TRIPLE_BACKTICK_PLACEHOLDER>";

SLKRegx* bold_rx;
SLKRegx* code_rx;
SLKRegx* emoji_rx;
SLKRegx* i_rx;
SLKRegx* jumbomoji_rx;
SLKRegx* long_quote_rx;
SLKRegx* pre_rx;
SLKRegx* quote_rx;
SLKRegx* strike_rx;
SLKRegx* url_rx;

NSString* _bold_rx = @"(^|\\s|[/\\?\\.,\\-!\\^;:{(\\[%$#+=\\u2000-\\u206F\\u2E00-\\u2E7F\"])\\*(.*?\\S *)?\\*(?=$|\\s|[/\\?\\.,'\\-!\\^;:})\\]%$~{\\[<#+=\\u2000-\\u206F\\u2E00-\\u2E7F\u2026\"\\uE022])";
NSString* _pre_rx = @"(^|\\s|[_*\\?\\.,\\-!\\^;:{(\\[%$#+=\\u2000-\\u206F\\u2E00-\\u2E7F\"])```([\\s\\S]*?)?```(?=$|\\s|[_*\\?\\.,\\-!\\^;:})\\]%$#+=\\u2000-\\u206F\\u2E00-\\u2E7F\u2026\"])";
NSString* _i_rx = @"(?!:.+:)(^|\\s|[/\\?\\.,\\-!\\^;:{(\\[%$#+=\\u2000-\\u206F\\u2E00-\\u2E7F\"])_(.*?\\S *)?_(?=$|\\s|[/\\?\\.,'\\-!\\^;:})\\]%$~{\\[<#+=\\u2000-\\u206F\\u2E00-\\u2E7F\u2026\"\\uE022])";
NSString* _strike_rx = @"(^|\\s|[/\\?\\.,\\-!\\^;:{(\\[%$#+=\\u2000-\\u206F\\u2E00-\\u2E7F\"])~(.*? *\\S)?~(?=$|\\s|[/\\?\\.,'\\-!\\^;:})\\]%$~{\\[<#+=\\u2000-\\u206F\\u2E00-\\u2E7F\u2026\"\\uE022])";
NSString* _code_rx = @"(^|\\s|[\\*\\\\/\\?\\.,\\-!\\^;:{(\\[%$#+=\\u2000-\\u206F\\u2E00-\\u2E7F\"])`([^`\n]*?\\S *)?`";
NSString* _quote_rx = @"(^|\n)&gt;(?![\\W_](?:&lt;|&gt;|[\\|/\\\\\\[\\]{}\\(\\)Dpb](?=\\s|$)))(([^\n]*)(\n&gt;[^\n]*)*)";
NSString* _emoji_rx = @":[a-zA-Z0-9-_+]+:(:skin-tone-[2-6]:)?";
NSString* _jumbomoji_rx = @"^(:[a-zA-Z0-9-_+]+:(:skin-tone-[2-6]:)*(?:\\u200D|(\\u200D(\u2640|\u2640\ufe0f|\u2642|\u2642\ufe0f)))?(\\s)*){1,23}$";
NSString* _long_quote_rx = @"(^|\n)&gt;&gt;&gt;([\\s\\S]*$)";
NSString* _url_rx = @"((ftp|http|https|file)://|\\bw{3}\\.)[a-z0-9\\-\\.]+[a-z]+(:[a-z0-9]*)?/?([@a-z0-9\\-\\._\\?,'\\(\\)\\*/\\\\\\+&amp;%:!$#=~*])*";


@interface SLKMessageParser(){
    NSString* mode;
    NSString* placeholder_base;
    NSUInteger placeholder_cnt;
    NSDictionary* flags;
}

@end



@implementation SLKMessageParser

+(void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bold_rx = [[SLKRegx alloc] initWithRegxStr:_bold_rx options:0];
        pre_rx = [[SLKRegx alloc] initWithRegxStr:_pre_rx options:0];
        code_rx = [[SLKRegx alloc] initWithRegxStr:_code_rx options:0];
        i_rx = [[SLKRegx alloc] initWithRegxStr:_i_rx options:0];
        strike_rx = [[SLKRegx alloc] initWithRegxStr:_strike_rx options:0];
        quote_rx = [[SLKRegx alloc] initWithRegxStr:_quote_rx options:0];
        emoji_rx = [[SLKRegx alloc] initWithRegxStr:_emoji_rx options:0];
        jumbomoji_rx = [[SLKRegx alloc] initWithRegxStr:_jumbomoji_rx options:0];
        long_quote_rx = [[SLKRegx alloc] initWithRegxStr:_long_quote_rx options:0];
        url_rx = [[SLKRegx alloc] initWithRegxStr:_url_rx options:NSRegularExpressionCaseInsensitive];
        
    });
}

-(NSString*)mode
{
    return mode;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        placeholder_base = @"\ue022-\ue022";
        placeholder_cnt = 0;
    }
    
    return self;
}

-(instancetype)initWithMode:(NSString*)m flags:(NSDictionary*)f
{
    self = [self init];
    if(self){
        mode = [m copy];
        flags = [f copy];
    }
    
    return self;
}

-(NSArray*)getTokensArray:(NSString*)message mode:(NSString*)modex flag:(NSDictionary*)flagsx
{
    mode = [modex copy];
    flags = [flagsx copy];
    message = [self getTokensString:message];
    
    NSMutableArray* array = [@[@(0)] mutableCopy];
    NSMutableArray* array2 = [@[] mutableCopy];

    SLKRegx* regx = [[SLKRegx alloc] initWithRegxStr:@"<(.*?)>" options:0];
    [regx map:message handler:[[SLKTokenArrayHandler alloc] initWithPaser:self
                                                                   startPos:array
                                                                     string:message
                                                                     before:[@[] mutableCopy]
                                                                      array:array2]];
    
    NSString* subStr = [message substringFromIndex:[array[0] integerValue]];
    if(subStr.length>0){
        [array2 addObject:subStr];
    }
    
    return array2;
}


-(NSString*)encodeOutGoingMarkup:(NSString*)str
{
    if(str.length == 0){
        return @"";
    }
    
    str = [str replaceWithRegx:@"&" string:@"&amp;"];
    str = [str replaceWithRegx:@"<" string:@"&lt;"];
    str = [str replaceWithRegx:@">" string:@"&gt;"];

    return str;
}

-(NSString*)swapOutPlaceholders:(NSArray*)array string:(NSString*)string
{
    NSMutableArray* placeholders = [array mutableCopy];
    while(placeholders.count>0) {
        NSDictionary* p = placeholders.lastObject;
        NSString* value = p[@"str"];
        value = [value replaceWithRegx:@"\\$" string:@"$$"];
        string = [string replaceWithRegx:p[@"placeholder"] string:value];
        [placeholders removeLastObject];
    }
    return string;
}

-(NSString*)getTokensString:(NSString*)message
{
    message = [message trim];
    
    if(!([mode isEqualToString:@"NORMAL"]
         || ![mode isEqualToString:@"EDIT"]
         || ![mode isEqualToString:@"GROWL"]
         || ![mode isEqualToString:@"CLEAN"]
         || ![mode isEqualToString:@"NOMRKDWN"])){
        // not support yet.
        return message;
    }
    
    
    if(message.length == 0){
        return @"";
    }
    
    NSMutableArray* array1 = [NSMutableArray new];
    NSMutableArray* array2 = [NSMutableArray new];
    if (![self.mode isEqualToString: @"CLEAN"]) {
        message = [self doMarkup:message output1:array1 output2:array2 mode:self.mode];
    }
    message = [message replaceWithRegx:@"^([\\u200B]+|[\\u200B]+)$" string:@""];
    if ([self.mode isEqualToString: @"CLEAN"]){
        message = [self encodeOutGoingMarkup:message];
    }
    else {
        if(![mode isEqualToString:@"NORMAL"]){
            if(![mode isEqualToString:@"NOMRKDWN"]){
                return [self swapOutPlaceholders:array2 string:[self swapOutPlaceholders:array1 string:message]];
            }
        }
        
        message = [message replaceWithRegx:@"<" string:@"&lt;"];
        message = [message replaceWithRegx:@">" string:@"&gt;"];
        
        NSMutableArray* array3 = [NSMutableArray new];
        if(![mode isEqualToString:@"NOMRKDWN"]){
            message = [self doSpecials:message output:array3];
        }
        message = [self doEmoji:message output:array2 flag:YES];
        
        SLKRegx* regx = [[SLKRegx alloc] initWithRegxStr:@"(\\W|^)(#[A-Fa-f0-9]{6})(\\b)" options:0];
        NSString* t = [regx map:message handler:[[SLKTokensStringHandlerHex alloc] initWithPaser:self array:nil]];
        message = [self swapOutPlaceholders:array3 string:t];
        
        message = [message replaceWithRegx:@"<CODE:START> " string:[NSString stringWithFormat:@"%@%@", CODE_START, SPACE_HARD]];
        message = [message replaceWithRegx:@" <CODE:END>" string:[NSString stringWithFormat:@"%@%@", SPACE_HARD, CODE_END]];
        
        for(NSInteger i=0;i<2;++i){
            regx = [[SLKRegx alloc] initWithRegxStr:@"(.)\n(.)" options:0];
            message = [regx map:message handler:[[SLKTokensStringHandlerBlankLine alloc] initWithPaser:self array:nil]];
        }
        
        regx = [[SLKRegx alloc] initWithRegxStr:@"(.)\n" options:0];
        message = [regx map:message handler:[[SLKTokensStringHandlerBlankLine2 alloc] initWithPaser:self array:nil]];
        
        message = [message replaceWithRegx:@"\n" string:PARA_BREAK];
        message = [message replaceWithRegx:@"<LINE:BREAK><PRE:START>" string:PRE_START];
        message = [message replaceWithRegx:@"<LINE:BREAK><QUOTE:START>" string:QUOTE_START];
        message = [message replaceWithRegx:@"<PRE:END><LINE:BREAK>" string:PRE_END];
        message = [message replaceWithRegx:@"<QUOTE:END><LINE:BREAK>" string:QUOTE_END];
        message = [message replaceWithRegx:@"&nbsp;&nbsp;" string:[NSString stringWithFormat:@" %@", LINE_BREAK]];
        message = [message replaceWithRegx:@"\t" string:[NSString stringWithFormat:@"%@%@%@%@", SPACE_HARD, SPACE_HARD, SPACE_HARD, SPACE_HARD]];
        message = [message replaceWithRegx:@"  " string:[NSString stringWithFormat:@" %@", SPACE_HARD]];
        message = [message replaceWithRegx:@"^ " string:SPACE_HARD];
    }
    
    return [self swapOutPlaceholders:array2 string:[self swapOutPlaceholders:array1 string:message]];
}


-(NSString*)placeholdStr:(NSMutableArray*)array message:(NSString*)message
{
    NSMutableString* finalString = [NSMutableString new];
    if(message.length == 0){
        return @"";
    }
    
    NSString* prefix = @"";
    
    if([message hasPrefix:@"\n"]){
        prefix = @"";
    }
    [finalString appendString:prefix];
    [finalString appendString:placeholder_base];
        
    [finalString appendFormat:@"%lu-", placeholder_cnt];
    
    placeholder_cnt++;
    
    [array addObject:@{
                       @"placeholder" : [finalString copy],
                       @"str" : [message copy],

                       }];
    
    return finalString;
}

-(BOOL)isLabelUrl:(NSString*)str1 and:(NSString*)str2
{
    if(str1.length == 0 || str2.length == 0){
        return NO;
    }
    else {
        if(![str1 isEqualToString:str2]){
            NSString* urlProtocol = [self urlProtocol:str2];
            if(urlProtocol.length != 0){
                if([str2 isEqualToString:[NSString stringWithFormat:@"%@%@", str1, urlProtocol]]){
                    return YES;
                }
            }
        }
    }
    
    return NO;
    
}

-(NSString*)urlProtocol:(NSString*)str
{
    SLKRegx* regx = [[SLKRegx alloc] initWithRegxStr:@"^\\w+://" options:NSRegularExpressionCaseInsensitive];
    return [regx map:str handler:[[SLKUrlHandler alloc] initWithPaser:self array:[NSMutableArray new]]];
}

-(NSString*)doSpecials:(NSString*)string output:(NSMutableArray*)array
{
    NSString* replacedString;
    replacedString = [pre_rx map:string handler:[[SLKSpecialsHandlerPre alloc] initWithPaser:self array:array]];
    replacedString = [replacedString replace:@"```" string:TBT_PLACEHOLDER];
    
    replacedString = [code_rx map:replacedString handler:[[SLKSpecialsHandlerCode alloc] initWithPaser:self array:array]];
    replacedString =[replacedString replace:TBT_PLACEHOLDER string:@"```"];
    
    replacedString = [i_rx map:replacedString handler:[[SLKSpecialsHandlerItalics alloc] initWithPaser:self array:array]];
    
    replacedString = [bold_rx map:replacedString handler:[[SLKSpecialsHandlerBold alloc] initWithPaser:self array:array]];

    replacedString = [strike_rx map:replacedString handler:[[SLKSpecialsHandlerStrike alloc] initWithPaser:self array:array]];

    replacedString = [long_quote_rx map:replacedString handler:[[SLKSpecialsHandlerLongQuote alloc] initWithPaser:self array:array]];
    
    replacedString = [quote_rx map:replacedString handler:[[SLKSpecialsHandlerQuote alloc] initWithPaser:self array:array]];

    
    return replacedString;
}
-(NSString*)removeSmartQuotes:(NSString*)string
{
    if(string.length == 0){
        return string;
    }
    
    string = [string replaceWithRegx:@"[\\u2018\\u2019]" string:@"'"];
    string = [string replaceWithRegx:@"[\\u201C\\u201D]" string:@"\""];

    return string;


}
-(NSString*)encodeForPre:(NSString*)string
{
    if(string.length == 0){
        return string;
    }
    
    string = [string replaceWithRegx:@"&" string:@"&amp;"];
    string = [string replaceWithRegx:@"<" string:@"&lt;"];
    string = [string replaceWithRegx:@">" string:@"&gt;"];
    
    return string;
}

-(NSString*)doMarkup:(NSString*)string output1:(NSMutableArray*)array1 output2:(NSMutableArray*)emojiArray mode:(NSString*)modex
{
    SLKRegx* regx = [[SLKRegx alloc] initWithRegxStr:@"<(.*?)>" options:0];
    return [regx map:string handler:[[SLKMarkupHandler alloc] initWithPaser:self string:[@[string] mutableCopy] array:array1 emojiArray:emojiArray mode:modex]];

}

-(NSString*)doEmoji:(NSString*)string output:(NSMutableArray*)array flag:(BOOL)f
{
    NSString* emojiTag = @"EMOJI";
    if(f && flags && [flags[@"jumbomoji"] boolValue]){
        if([jumbomoji_rx match:string]){
            emojiTag = @"JUMBOMOJI";
        }
    }
    
    return [emoji_rx map:string handler:[[SLKEmojiHandler alloc] initWithPaser:self token:emojiTag array:array]];
}

//-(void)dealloc
//{
//    NSLog(@"dealloc %@", [self class]);
//}
@end
