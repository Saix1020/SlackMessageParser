//
//  SLKMessageToken+Display.m
//  SLKMessageDemo
//
//  Created by saix on 2017/9/18.
//  Copyright © 2017年 sai. All rights reserved.
//

#import "SLKMessageToken+Display.h"
#import "NSString+SLKMessageParser.h"
#import "SLKLinkRect.h"
#import "UIColor+SLKMessageParser.h"

#define kCodeFontSize 14.f
#define kTextFontSize 14.f
#define kJumbomojiFontSize 32.f


@interface SLKMessageToken ()
//@property (nonatomic, strong) id displayElement;

@end

@implementation SLKMessageToken (Display)
-(id)_displayElement
{
    switch (self.type) {
        case SLKMessageTokenLINE_BREAK:
            return [[NSMutableAttributedString alloc] initWithString:@"\n"];
            
        case SLKMessageTokenSPACE_HEAD:
            return [[NSMutableAttributedString alloc] initWithString:@" "];
            
        case SLKMessageTokenCODE:
            return [self _displayElementOfCode];
            
        case SLKMessageTokenLINK:
            return [self _displayElementOfLink];
            
        case SLKMessageTokenHEX_BLOCK:
            return [self _displayElementOfHex];
            
        case SLKMessageTokenTEXT:
            return [self _displayElementOfText];
            
        case SLKMessageTokenPRE:
            return [self _displayElementOfPre];
            
        case SLKMessageTokenQUOTE:
            // never be here!
            break;
            
        case SLKMessageTokenEMOJI:
        case SLKMessageTokenJUMBOMOJI:
            return [self _displayElementOfEmoji];
        
            
        case SLKMessageTokenUSER:
            return [self _displayElementOfUser];
            
        case SLKMessageTokenCHANNEL:
            return [self _displayElementOfChannel];

        case SLKMessageTokenCOMMAND:
            return [self _displayElementOfCommand];

        case SLKMessageTokenQuotePrefix:
            return [self _displayElementOfQuotePrefix];
            
            
        default:
            break;
    }
    
    return [[NSMutableAttributedString alloc] initWithString:@""];;
}

-(NSAttributedString*)attributedString
{
    return [self _displayElement];
}


-(NSMutableAttributedString*)_displayElementOfUser
{
    if (!self.isUserLink) {
        return [NSMutableAttributedString new];
    }
    
    UserLink* userLink = self.userLink;
    NSString* label = userLink.label;
    if (label.length == 0) {
        label = userLink.payload;
    }
    label = [NSString stringWithFormat:@"@%@", label];
    NSString* value = [NSString stringWithFormat:@"SLKUser:%@", userLink.payload];
    return [self _displayElementOfCommandMarkupWithLabel:label value:value];
    
}

-(NSMutableAttributedString*)_displayElementOfChannel
{
    if (!self.isChannelLink) {
        return [NSMutableAttributedString new];
    }
    
    ChannelLink* userLink = self.channelLink;
    NSString* label = userLink.label;
    if (label.length == 0) {
        label = userLink.payload;
    }
    label = [NSString stringWithFormat:@"#%@", label];

    
    NSString* value = [NSString stringWithFormat:@"SLKChannel:%@", userLink.payload];
    return [self _displayElementOfCommandMarkupWithLabel:label value:value];
    
}


-(NSMutableAttributedString*)_displayElementOfCommand
{
    if (!self.isCommand) {
        return [NSMutableAttributedString new];
    }
    
    Command* userLink = self.command;
    NSString* label = userLink.label;
    if (label.length == 0) {
        label = userLink.payload;
    }
    label = [NSString stringWithFormat:@"#%@", label];

    NSString* value = [NSString stringWithFormat:@"SLKCommand:%@", userLink.payload];
    return [self _displayElementOfCommandMarkupWithLabel:label value:value];
    
}

-(NSMutableAttributedString*)_displayElementOfCommandMarkupWithLabel:(NSString*)label value:(NSString*)value
{
    UIFont* font = [UIFont systemFontOfSize:kTextFontSize];

    NSMutableDictionary* attributes = [@{
                                         NSFontAttributeName : [UIFont fontWithName:@"Lato-Regular" size:16.f],
                                         NSForegroundColorAttributeName : _RGBCOLOR(0x005E99),
                                         //NSLinkAttributeName : value
                                         @"kSLKLinkAttribute" : [[SLKLinkRect alloc] initWithUrl:value],
                                         } mutableCopy];
    if (self.spanStyle & kSLKMessageTokenSpanB) {
        UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:font.fontName size:font.pointSize];
        
        NSString *boldFontName = [[fontDescriptor fontDescriptorWithSymbolicTraits:fontDescriptor.symbolicTraits|UIFontDescriptorTraitBold].fontAttributes valueForKey:UIFontDescriptorNameAttribute];
        
        font = [UIFont fontWithName:boldFontName size:font.pointSize];
    }
    
    if (self.spanStyle & kSLKMessageTokenSpanI) {
        UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:font.fontName size:font.pointSize];
        
        NSString *boldFontName = [[fontDescriptor fontDescriptorWithSymbolicTraits:fontDescriptor.symbolicTraits|UIFontDescriptorTraitItalic].fontAttributes valueForKey:UIFontDescriptorNameAttribute];
        
        font = [UIFont fontWithName:boldFontName size:font.pointSize];
    }
    attributes[NSFontAttributeName] = font;
    attributes[NSForegroundColorAttributeName] = _RGBCOLOR(0x005E99);
    
    if (self.spanStyle & kSLKMessageTokenSpanSTRIKE) {
        attributes[NSBaselineOffsetAttributeName] = @0;
        attributes[NSStrikethroughStyleAttributeName] = @2;
    }
    
    return [[NSMutableAttributedString alloc] initWithString:label
                                                  attributes:attributes];

}

-(NSMutableAttributedString*)_displayElementOfText
{
    NSString* string = [self.string decodeGTLTAND];
    UIFont* font = [UIFont fontWithName:@"Lato-Regular" size:16.f];//[UIFont systemFontOfSize:kTextFontSize];
    NSMutableDictionary* attributes = [@{} mutableCopy];
    if (self.spanStyle & kSLKMessageTokenSpanB) {
        UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:font.fontName size:font.pointSize];
        
        NSString *boldFontName = [[fontDescriptor fontDescriptorWithSymbolicTraits:fontDescriptor.symbolicTraits|UIFontDescriptorTraitBold].fontAttributes valueForKey:UIFontDescriptorNameAttribute];
        
        font = [UIFont fontWithName:boldFontName size:font.pointSize];
    }
    
    if (self.spanStyle & kSLKMessageTokenSpanI) {
        UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:font.fontName size:font.pointSize];
        
        NSString *boldFontName = [[fontDescriptor fontDescriptorWithSymbolicTraits:fontDescriptor.symbolicTraits|UIFontDescriptorTraitItalic].fontAttributes valueForKey:UIFontDescriptorNameAttribute];
        
        font = [UIFont fontWithName:boldFontName size:font.pointSize];
    }
    attributes[NSFontAttributeName] = font;
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    if (self.spanStyle & kSLKMessageTokenSpanSTRIKE) {
        attributes[NSBaselineOffsetAttributeName] = @0;
        attributes[NSStrikethroughStyleAttributeName] = @2;
    }
    
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    return [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
}



-(NSMutableAttributedString*)_displayElementOfCode
{
    NSMutableString* string = [NSMutableString new];
    [self.subTokens enumerateObjectsUsingBlock:^(SLKMessageToken*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendString:obj.string];
    }];
    return [[NSMutableAttributedString alloc] initWithString:string attributes:@{
                                                                                 NSFontAttributeName : [UIFont fontWithName:@"Menlo-Regular" size:kCodeFontSize],
                                                                                 NSForegroundColorAttributeName : _RGBCOLOR(0xcc2255),
//                                                                                 NSBackgroundColorAttributeName : _RGBCOLOR(0xf7f7f9),
//                                                                                 NSParagraphStyleAttributeName: style,
                                                                                 @"kSLKCodeAttribute" : @1
                                                                                 // border 0xe1e1e8
                                                                                 }];
}
-(NSArray*)_displayElementOfPre
{
    NSMutableString* string = [NSMutableString new];
    [string appendString:@" "];
    [self.subTokens enumerateObjectsUsingBlock:^(SLKMessageToken*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendString:obj.string];
    }];
    [string appendString:@" "];
    NSMutableAttributedString* result = [[NSMutableAttributedString alloc] initWithString:string attributes:@{
                                                                                 NSFontAttributeName : [UIFont fontWithName:@"courier" size:kCodeFontSize],
                                                                                 NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                 NSBackgroundColorAttributeName : _RGBCOLOR(0xf7f7f9),
                                                                                 // border 0xe1e1e8
                                                                                 }];
    return @[@"PRE", result];
}

-(NSMutableAttributedString*)_displayElementOfLink
{
    NSString* value = self.startToken.paramValue;
    NSString* text = value;;
    if(self.subTokens.count>0){
        SLKMessageToken* subToken = self.subTokens.firstObject;
        text = subToken.token;
    }
    
    return [[NSMutableAttributedString alloc] initWithString:text
                                                  attributes:@{
                                                               NSFontAttributeName : [UIFont systemFontOfSize:kTextFontSize],
                                                               NSForegroundColorAttributeName : _RGBCOLOR(0x005E99),
                                                               @"kSLKLinkAttribute" : [[SLKLinkRect alloc] initWithUrl:value],
                                                               }];;
    
}

-(NSMutableAttributedString*)_displayElementOfHex
{
    NSUInteger color = [[self.paramValue substringFromIndex:1] hex];
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@" ■" attributes:@{
                                                                                               NSFontAttributeName : [UIFont systemFontOfSize:kTextFontSize+2],
                                                                                               NSForegroundColorAttributeName : _RGBCOLOR(color),
                                                                                               }];
    
    return attrString;
}


//-(NSArray*)_displayElementOfQuote
//{
//    NSMutableArray* array = [@[@"QUOTE"] mutableCopy];
//
//    [self.subTokens enumerateObjectsUsingBlock:^(SLKMessageToken* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [array addObject:obj.displayElement];
//    }];
//
//    return array;
//}

-(NSAttributedString*)_displayElementOfEmoji
{
    NSString* value = self.paramValue;
    NSString* emoji = [value decodeEmoji];
    CGFloat fontSize = kTextFontSize;
    if (self.isJumbomoji) {
        fontSize = kJumbomojiFontSize;
    }
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:emoji
                                                                                   attributes:@{
                                                                                                NSFontAttributeName : [UIFont systemFontOfSize:fontSize]                                                                                                                 }];
    return attrString;

}

-(NSAttributedString*)_displayElementOfQuotePrefix
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"\n"
                                                                                   attributes:@{
                                                                                                NSFontAttributeName : [UIFont systemFontOfSize:2]                                                                                                                 }];
    return attrString;
}



@end
