//
//  SLKMessageContainer2.h
//  SLKMessageDemo
//
//  Created by saix on 2017/9/26.
//  Copyright © 2017年 sai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@class  SLKMessageToken;

typedef enum : NSUInteger {
    SLKMessageComponentTypeNomal = 0,
    SLKMessageComponentTypeQuote,
    SLKMessageComponentTypePre,
} SLKMessageComponentType;
@class SLKMessageTextComponent;

@interface SLKMessageComponent : NSObject

@property (nonatomic) CGRect frame;
@property (nonatomic) SLKMessageComponentType type;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) CGFloat lineFragmentPadding;

@property (nonatomic, copy) NSString* message;

@property (nonatomic, weak) SLKMessageComponent* superComponent;
@property (nonatomic, strong) NSMutableArray<SLKMessageComponent*>* subComponents;
@property (nonatomic, strong) SLKMessageTextComponent* currentTextComponent;

@property (nonatomic) CTFrameRef ctFrameRef;

-(instancetype)initWithFrame:(CGRect)frame andType:(SLKMessageComponentType)type;
-(void)addSubComponent:(SLKMessageComponent*)subComponent;
-(void)addSLKMessageTokens:(NSArray<SLKMessageToken*>*)tokens;

-(void)draw;
-(void)drawWithContent:(CGContextRef)context;

-(void)getLinkRectsInto:(NSMutableArray*)linkRects andCodeRectsInto:(NSMutableArray*)codeRects;


@end

@interface SLKMessageTextComponent : SLKMessageComponent

@property (nonatomic, strong) NSMutableAttributedString* attributedString;
-(void)appendAttributedString:(NSAttributedString*)attrString;
-(void)format;
@end

@interface SLKMessageQuoteComponent : SLKMessageComponent

@end

@interface SLKMessagePreComponent : SLKMessageComponent

@end
