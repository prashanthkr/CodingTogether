//
//  SetCard.h
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 4/10/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card


//@property (strong, nonatomic)NSString *cardContents;
//@property (strong, nonatomic)NSAttributedString *cardShapes;
@property (nonatomic) NSUInteger rank;
//@property (strong, nonatomic)NSString *color;
+(NSArray *)validShapes;
+(NSArray *)validColors;
+(NSUInteger)maxRank;
@end
