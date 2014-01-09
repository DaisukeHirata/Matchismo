//
//  PlayingCard.m
//  Matchismo
//
//  Created by Daisuke Hirata on 2013/12/27.
//  Copyright (c) 2013年 Daisuke Hirata. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1 || [otherCards count] == 2) {
        
        NSMutableDictionary *ranks = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *suits = [[NSMutableDictionary alloc] init];
        
        // counting rank and suit
        [ranks setObject:[NSNumber numberWithInt:0] forKey:[NSNumber numberWithInt:self.rank]];
        [suits setObject:[NSNumber numberWithInt:0] forKey:self.suit];
        
        for (PlayingCard *otherCard in otherCards) {
            int rankCountInt = 0;
            if ([ranks objectForKey:[NSNumber numberWithInt:otherCard.rank]]) {
                NSNumber *rankCount = [ranks objectForKey:[NSNumber numberWithInt:otherCard.rank]];
                rankCountInt = [rankCount intValue] + 1;
            }
            [ranks setObject:[NSNumber numberWithInt:rankCountInt] forKey:[NSNumber numberWithInt:otherCard.rank]];
            
            int suitCountInt = 0;
            if ([suits objectForKey:otherCard.suit]) {
                NSNumber *suitCount = [suits objectForKey:otherCard.suit];
                suitCountInt = [suitCount intValue] + 1;
            }
            [suits setObject:[NSNumber numberWithInt:suitCountInt] forKey:otherCard.suit];
        }
        
        // scoring based on above
        for (NSNumber *rank in ranks) {
            NSNumber *rankCount = [ranks objectForKey:rank];
            int value = [rankCount intValue];
            score += value * 5;
        }
        
        for (NSString *suit in suits) {
            NSNumber *suitCount = [suits objectForKey:suit];
            int value = [suitCount intValue];
            score += value * 2;
        }
    }

    return score;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter AND getter

+ (NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count]-1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
