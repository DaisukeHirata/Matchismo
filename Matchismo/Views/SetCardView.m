//
//  SetCardView.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2014/01/14.
//  Copyright (c) 2014年 Daisuke Hirata. All rights reserved.
//

#import "SetCardView.h"

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
#define CORNER_RADIUS 12.0
#define PIP_FONT_SCALE_FACTOR 0.45
#define CORNER_OFFSET 3.0
#define CARD_STROKE 7.0
#define PIP_HOFFSET_PERCENTAGE 0.265
#define PIP_VOFFSET1_PERCENTAGE 0.140
#define PIP_VOFFSET2_PERCENTAGE 0.280
#define PIP_VOFFSET3_PERCENTAGE 0.420

@interface SetCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@property (nonatomic) CGFloat faceCardFontScaleFactor;
@end

@implementation SetCardView

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

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - drawing functions

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    if (self.faceUp) {
        [self drawPips];
        //[self drawCardData];
    } else {
        [[UIImage imageNamed:@"cardback.png"] drawInRect:self.bounds];
    }
    
    [[UIColor blackColor] setStroke];
//    [roundRect setLineWidth:CARD_STROKE];
    [roundRect stroke];
}

- (void)drawCardData {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * self.faceCardFontScaleFactor];

    NSString *strForCornerText = [NSString stringWithFormat:@"%@", [self numberAsString:self.number]];
    strForCornerText = [NSString stringWithFormat:@"%@\n%@", strForCornerText, self.symbol];
    strForCornerText = [NSString stringWithFormat:@"%@\n%@", strForCornerText, self.shading];
    strForCornerText = [NSString stringWithFormat:@"%@\n%@", strForCornerText, self.color];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:strForCornerText
                                                 attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont}];

    CGRect textBounds;
    
    //draw the attributes in the left top corner
    textBounds.origin = CGPointMake(CORNER_OFFSET, CORNER_OFFSET);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)drawPips
{
    if ((self.number == 1) || (self.number == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0];
    }
    if ((self.number == 2) || (self.number == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE];
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:-PIP_VOFFSET2_PERCENTAGE];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat fontScale = ![self.symbol isEqualToString:@"●"] ? self.faceCardFontScaleFactor : self.faceCardFontScaleFactor + 0.40;
    UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * fontScale];

    UIColor *foregroundColor = [self foregroundColorAsUIColor:self.color shading:self.shading];
    NSAttributedString *attributedSuit =
        [[NSAttributedString alloc] initWithString:self.symbol
                                        attributes:
                                            @{ NSFontAttributeName            : pipFont,
                                               NSForegroundColorAttributeName : foregroundColor,
                                               NSStrokeWidthAttributeName     : @-5,
                                               NSStrokeColorAttributeName     : [self strokeColorAsUIColor:self.color] } ];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
}

- (NSString *) numberAsString:(NSUInteger)number
{
    return @[@"?",@"1",@"2",@"3"][number];
}

- (UIColor *) foregroundColorAsUIColor:(NSString *)color shading:(NSString *)shading
{
    NSDictionary *colors = @{@"red"    : [UIColor redColor],
                             @"green"  : [UIColor greenColor],
                             @"purple" : [UIColor purpleColor],
                             @"open"   : [UIColor whiteColor]};
    UIColor *c = colors[[shading isEqualToString:@"open"] ? @"open" : color];
    NSLog(@"%@", shading);
    return [shading isEqualToString:@"striped"] ? [c colorWithAlphaComponent:0.3] : c;
}

- (UIColor *) strokeColorAsUIColor:(NSString *)color
{
    NSDictionary *colors = @{@"red"    : [UIColor redColor],
                             @"green"  : [UIColor greenColor],
                             @"purple" : [UIColor purpleColor]};
    return colors[color];
}

@end
