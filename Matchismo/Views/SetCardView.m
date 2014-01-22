//
//  SetCardView.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2014/01/14.
//  Copyright (c) 2014年 Daisuke Hirata. All rights reserved.
//

#import "SetCardView.h"

#define PIP_VOFFSET2_PERCENTAGE 0.280

@interface SetCardView()
@end

@implementation SetCardView

#pragma mark - Getters and Setters

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

#pragma mark - drawing functions

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    if (self.faceUp) {
        [self drawPips];
    } else {
        [[UIImage imageNamed:@"cardback.png"] drawInRect:self.bounds];
    }
    
    [[UIColor blackColor] setStroke];
    [roundRect stroke];
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
    NSAttributedString *attributedSuit = [self createAttributedString];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake( middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                     middle.y-pipSize.height/2.0-voffset*self.bounds.size.height );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
}

- (NSAttributedString *)createAttributedString
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    CGFloat fontScale = ![self.symbol isEqualToString:@"●"] ? self.faceCardFontScaleFactor : self.faceCardFontScaleFactor + 0.40;
    UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * fontScale];
    
    [attributes setObject:pipFont forKey:NSFontAttributeName];
    
    if ([self.color isEqualToString:@"red"])
        [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    if ([self.color isEqualToString:@"green"])
        [attributes setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
    if ([self.color isEqualToString:@"purple"])
        [attributes setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
    if ([self.shading isEqualToString:@"solid"])
        [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
    if ([self.shading isEqualToString:@"striped"])
        [attributes addEntriesFromDictionary:@{
                                               NSStrokeWidthAttributeName : @-5,
                                               NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                                               NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.1]
                                               }];
    if ([self.shading isEqualToString:@"open"])
        [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
    
    NSAttributedString *attributedSymbol = [[NSAttributedString alloc] initWithString:self.symbol
                                                                           attributes: attributes];
    
    return attributedSymbol;
}

- (NSString *) numberAsString:(NSUInteger)number
{
    return @[@"?",@"1",@"2",@"3"][number];
}

@end
