//
//  SetCard.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2014/01/14.
//  Copyright (c) 2014年 Daisuke Hirata. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1 || [otherCards count] == 2) {
        
        NSMutableDictionary *numbers  = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *symbols  = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *shadings = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *colors   = [[NSMutableDictionary alloc] init];
        
        // counting rank and suit
        [numbers setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:self.number]];
        [symbols setObject:[NSNumber numberWithInt:0] forKey:self.symbol];
        [shadings setObject:[NSNumber numberWithInt:0] forKey:self.shading];
        [colors setObject:[NSNumber numberWithInt:0] forKey:self.color];
        
        for (SetCard *otherCard in otherCards) {
            int numberCountInt = 0;
            if ([numbers objectForKey:[NSNumber numberWithInt:otherCard.number]]) {
                NSNumber *numberCount = [numbers objectForKey:[NSNumber numberWithInt:otherCard.number]];
                numberCountInt = [numberCount intValue] + 1;
            }
            [numbers setObject:[NSNumber numberWithInt:numberCountInt] forKey:[NSNumber numberWithInt:otherCard.number]];
            
            int symbolCountInt = 0;
            if ([symbols objectForKey:otherCard.symbol]) {
                NSNumber *symbolCount = [symbols objectForKey:otherCard.symbol];
                symbolCountInt = [symbolCount intValue] + 1;
            }
            [symbols setObject:[NSNumber numberWithInt:symbolCountInt] forKey:otherCard.symbol];
            
            int shadingCountInt = 0;
            if ([shadings objectForKey:otherCard.shading]) {
                NSNumber *shadingCount = [shadings objectForKey:otherCard.shading];
                shadingCountInt = [shadingCount intValue] + 1;
            }
            [shadings setObject:[NSNumber numberWithInt:shadingCountInt] forKey:otherCard.shading];
            
            int colorCountInt = 0;
            if ([colors objectForKey:otherCard.color]) {
                NSNumber *colorCount = [colors objectForKey:otherCard.color];
                colorCountInt = [colorCount intValue] + 1;
            }
            [colors setObject:[NSNumber numberWithInt:colorCountInt] forKey:otherCard.color];
        }
        
        // scoring based on above
        for (NSNumber *number in numbers) {
            NSNumber *numberCount = [numbers objectForKey:number];
            int value = [numberCount intValue];
            if (value == 2) score += value * 5;
        }
        
        for (NSString *symbol in symbols) {
            NSNumber *symbolCount = [symbols objectForKey:symbol];
            int value = [symbolCount intValue];
            NSLog(@"%d", value);
            if (value == 2) score += value * 2;
        }
        
        for (NSString *shading in shadings) {
            NSNumber *shadingCount = [shadings objectForKey:shading];
            int value = [shadingCount intValue];
            if (value == 2) score += value * 2;
        }
        
        for (NSString *color in colors) {
            NSNumber *colorCount = [colors objectForKey:color];
            int value = [colorCount intValue];
            if (value == 2) score += value * 2;
        }
    }

    return score;
}

- (NSString *)contents
{
    NSMutableString *contents = [[NSMutableString alloc] init];
    [contents appendFormat:@"%@", [SetCard numberStrings][self.number]];
    [contents appendFormat:@"%@", self.symbol];
    [contents appendFormat:@"%@", self.shading];
    [contents appendFormat:@"%@", self.color];
    return contents;
}

@synthesize symbol = _symbol; // because we provide setter AND getter

+ (NSArray *)validSymbols
{
    return @[@"▲",@"●",@"■"];
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString *)symbol
{
    return _symbol ? _symbol : @"?";
}

@synthesize shading = _shading; // because we provide setter AND getter

+ (NSArray *)validShadings
{
    return @[@"solid", @"striped", @"open"];
}

- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

- (NSString *)shading
{
    return _shading ? _shading : @"?";
}

@synthesize color = _color; // because we provide setter AND getter

+ (NSArray *)validColors
{
    return @[@"red", @"green", @"purple"];
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSString *)color
{
    return _color ? _color : @"?";
}

+ (NSArray *)numberStrings
{
    return @[@"?", @"1", @"2", @"3"];
}

+ (NSUInteger)maxNumber
{
    return [[self numberStrings] count]-1;
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}
@end
