//
//  CardView.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2014/01/21.
//  Copyright (c) 2014年 Daisuke Hirata. All rights reserved.
//

#import "CardView.h"

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
#define CORNER_RADIUS 12.0
#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define PIP_FONT_SCALE_FACTOR 0.20
#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

@interface CardView()
@end

@implementation CardView

#pragma mark - Initialization

- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)awakeFromNib {
    [self setup];
}


#pragma mark - Getters and Setters

@synthesize faceCardScaleFactor = _faceCardScaleFactor;
@synthesize faceCardFontScaleFactor = _faceCardFontScaleFactor;

- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (CGFloat)faceCardFontScaleFactor
{
    if (!_faceCardFontScaleFactor) _faceCardFontScaleFactor = PIP_FONT_SCALE_FACTOR;
    return _faceCardFontScaleFactor;
}

- (void)setFaceCardFontScaleFactor:(CGFloat)faceCardFontScaleFactor
{
    _faceCardFontScaleFactor = faceCardFontScaleFactor;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - drawing functions

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

@end
