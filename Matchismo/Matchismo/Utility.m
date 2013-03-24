//
//  Utility.m
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 3/16/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "Utility.h"

@implementation Utility
//Builds the string for the last flipped card.
+(NSString *)getResultString:(int)flipPoints
             forFlippedCards:(NSArray *)flippedCards
                 andGameMode:(NSUInteger) gameMode{
    
    NSRange subArrayRange;
    //For 2 gameMode, we look at last 2 cards, for 3 gameMode, look at last 3 cards.
    subArrayRange.location = flippedCards.count > gameMode ? (flippedCards.count-gameMode+1) : 0;//start index.
    subArrayRange.length = gameMode;//number of elements
}//end method
/*+(NSString *)getResultString:(int)flipPoints
      forCurrentCardContents:(NSString *)currentCardContents
     andPreviousCardContents:(NSString *)previousCardContents{
    NSString *resultString;
//    NSLog(@"card in utility----%d",flipPoints);
//    NSLog(@"currentCardContents in utility----%@",currentCardContents);
//    NSLog(@"card in previousCardContents----%@",previousCardContents);
    if(flipPoints >0){
        resultString = [NSString stringWithFormat:@"Matched %@ and %@ for %d points", currentCardContents, previousCardContents, flipPoints];
    }else if(flipPoints == 0){
        resultString = [NSString stringWithFormat:@"Flipped %@", currentCardContents];
    }else{
        resultString = [NSString stringWithFormat:@"%@ and %@ don't match. %d point penalty!", currentCardContents, previousCardContents, flipPoints];
    }
    return resultString;
}
 */
@end
