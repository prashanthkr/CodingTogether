//
//  SetCard.m
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 4/10/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
//@synthesize cardContents = _cardContents;

//Override the match method from SuperClass Card
-(int)match:(NSArray *)otherCards
{
    int score = 0;
    //Calling [super match:..] isn't done here as this is independent of what is in the super class
    
    
    //Now should match any number of cards
    if(otherCards.count >1){
        NSRange subArrayRange;
        subArrayRange.location = 0;//start index
        subArrayRange.length = otherCards.count-1;//number of elements
        
        //for(Card* otherCard in otherCards){
        score += [self match:[otherCards subarrayWithRange:subArrayRange]];
        //}
    } else if(otherCards.count == 1){
        SetCard *otherCard = [otherCards lastObject];//lastObject is similar to [array ObjectAtIndex:array.count-1] and returns nil if array is empty
        if([otherCard.contents.string isEqualToString:self.contents.string]){
            score = 1;
        }
        
    }
    
    return score;
}

+ (NSArray *)validShapes
{
    static NSArray *validShapes = nil;
    if (!validShapes) {
        validShapes = @[@"▲", @"●", @"■"];
    }
    return validShapes;
}

+ (NSArray *)validColors
{
    static NSArray *validColors = nil;
    if (!validColors) {
        validColors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
    }
    return validColors;
}

//-(void)setCardContents:(NSString *)cardContents
//{
//    if([[SetCard validShapes] containsObject:cardContents]){
//        _cardContents = cardContents;
//    }
//}

/*-(NSAttributedString *) contents
{
//    return _cardContents? _cardContents: @"?";
    return self.cardShapes;
}
*/

+ (NSUInteger)maxRank
{
    return [self validShapes].count;
}


@end
