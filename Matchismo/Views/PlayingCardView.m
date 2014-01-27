//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Caio Uvini on 7/28/13.
//  Copyright (c) 2013 Caio Uvini. All rights reserved.
//

#import "PlayingCardView.h"

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
#define CORNER_RADIUS 12.0
#define PIP_FONT_SCALE_FACTOR 0.20
#define CORNER_OFFSET 3.0
#define CARD_STROKE 7.0
#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270


@interface PlayingCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@property (nonatomic) CGFloat faceCardFontScaleFactor;
@end

@implementation PlayingCardView

@synthesize faceCardScaleFactor = _faceCardScaleFactor;
@synthesize faceCardFontScaleFactor = _faceCardFontScaleFactor;

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

- (void)setSuit:(NSString *)suit {
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
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
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg", [self rankAsString:self.rank], self.suit]];
        if (faceImage) {
            CGRect imageRect = CGRectInset(self.bounds,
                                           self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                           self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
            [faceImage drawInRect:imageRect];
        } else {
            [self drawPips];
        }
        [self drawCardData];
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

    NSString *strForCornerText = [NSString stringWithFormat:@"%@", [self rankAsString:self.rank]];
    if ([@[@"J",@"Q",@"K"] containsObject:[self rankAsString:self.rank]]) {
        strForCornerText = [NSString stringWithFormat:@"%@\n%@", strForCornerText, self.suit];
    }
    
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
    if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank != 7)];
    }
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    if (upsideDown) [self pushContextAndRotateUpsideDown];
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * self.faceCardFontScaleFactor];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName : pipFont }];
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
    if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}

- (NSString *) rankAsString:(NSUInteger)rank {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][rank];
}

#pragma mark - gesture

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        self.faceCardScaleFactor *= gesture.scale;
        self.faceCardFontScaleFactor *= gesture.scale;
        gesture.scale = 1;
    }
    
}

@end
