//
//  PlayingCard.m
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 1/30/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

//Override the match method from SuperClass Card
-(int)match:(NSArray *)otherCards
{
    int score = 0;
    //Calling [super match:..] isn't done here as this is independent of what is in the super class
    
    
    //Now should match any number of cards
    if(otherCards.count >1){
        NSRange subArrayRange;
        subArrayRange.location = 0;//start index
        subArrayRange.length = otherCards.count-1;
        
        //for(Card* otherCard in otherCards){
        score += [self match:[otherCards subarrayWithRange:subArrayRange]];
        //}
    } else if(otherCards.count == 1){
        PlayingCard *otherCard = [otherCards lastObject];//lastObject is similar to [array ObjectAtIndex:array.count-1] and returns nil if array is empty
        if([otherCard.suit isEqualToString:self.suit]){
            score = 1;
        } else if(otherCard.rank == self.rank){
            score = 4;//there are 12 that match a card's suit, but only 3 that match its rank...that's why we give 4 times more for rank match
        }
        
        
    }
    
    return score;
}
-(NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) {
        validSuits = @[@"♥", @"♦",@"♠",@"♣"];
    }
    return validSuits;
}

-(void)setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

-(NSString *) suit
{
    return _suit? _suit: @"?";
}

+(NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    return rankStrings;
    
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}
@end
