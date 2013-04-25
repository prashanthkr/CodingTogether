//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Prashanth Reddy Kambalapally on 4/10/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck



-(id)init
{
    self = [super init];
    
    
    if(self)
    {
        //create 24 cards
        for(NSUInteger count = 1; count<=24;count++)
        {
            float randomNumber = [SetCardDeck getRandomNumberBetween:0 to :2];//24;//((float)arc4random() / 3 * 2) + 1;
                                                                              //NSLog(@"Random no---%f",randomNumber);
            //Each card will have 1 to 3 shapes of the same type. The colors will also be same for all the shapes on a card
            //But the number of shapes varies randomly from 1 to 3.
            float randomNumber2 = [SetCardDeck getRandomNumberBetween:0 to :2];
            //pick a random shape
            //pick a random color
            UIColor *chosenColor = [[SetCard validColors] objectAtIndex:randomNumber];
            NSString *chosenShape = [[SetCard validShapes] objectAtIndex:randomNumber2];
            NSString *cardContents=@"";
            for(NSUInteger rank=0; rank <= randomNumber;rank++)
            {
                
                cardContents = [cardContents stringByAppendingString:[@" " stringByAppendingString:chosenShape]];
                NSAttributedString* attrStr = [[NSAttributedString alloc]
                                               initWithString:cardContents
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14],NSForegroundColorAttributeName: chosenColor
                                               }];
                SetCard *card = [[SetCard alloc] init];
                card.contents = attrStr;
                [self addCard:card atTop:YES];
            }
                
           

//            NSLog(@"chosencolor---%@",chosenColor);
//            NSLog(@"color---%@",[[SetCard validColors] objectAtIndex:2]);
//            NSLog(@"chosen shape---%@",chosenShape);
//            NSLog(@"coloredshape---%@",attrStr.string);
//            NSLog(@"cardShapes---%@",card.cardShapes);
        }
    }
   /* if(self){
        for(NSString *shape in [SetCard validShapes]){
            for(NSUInteger rank=1; rank <= randomNumber; rank++
                ){
//                NSShadow * shadow = [[NSShadow alloc] init];
//                shadow.shadowColor = UIColor.redColor;
//                shadow.shadowBlurRadius = randomNumber*2;
                //[shadow shadowOffset: NSMakeSize(4.0, -4.0)];
                
                SetCard *card = [[SetCard alloc] init];
                 NSAttributedString* attrStr = [[NSAttributedString alloc ] initWithString:shape attributes :@{ NSFontAttributeName: [UIFont systemFontOfSize:24],
                    NSForegroundColorAttributeName: [UIColor redColor],
                                                //NSShadowAttributeName :shadow,
                    NSStrokeWidthAttributeName: @-5,
                    NSStrokeColorAttributeName: [UIColor blueColor],
                    NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}];
                //card.cardContents = [attrStr string];
            //card.cardContents = shape;
                [self addCard:card atTop:YES];
                
            }
        }
    }*/
    return self;
}
+(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

@end
