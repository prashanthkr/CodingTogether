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
@end
