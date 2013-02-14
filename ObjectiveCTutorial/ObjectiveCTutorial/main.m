//
//  main.m
//  ObjectiveCTutorial
//
//  Created by Prashanth Reddy Kambalapally on 2/3/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarUtilities.h"

#define PI 3.14159
#define RAD_TO_DEG(radians) (radians * (180.0 / PI))

typedef unsigned char ColorComponent;
typedef struct {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
} Color;

typedef enum {
    FORD,
    HONDA,
    NISSAN,
    PORSCHE
} CarModel;

int getRandomInteger(int minimum, int maximum) {
    return arc4random_uniform((maximum - minimum) + 1) + minimum;
}
NSString *getRandomMake(NSArray *makes) {
    int maximum = (int)[makes count];
    int randomIndex = arc4random_uniform(maximum);
    return makes[randomIndex];
}

// Declaration
NSString *getRandomMake2(NSArray *);

// Static function declaration
static int getRandomInteger3(int, int);

// Static function implementation
static int getRandomInteger3(int minimum, int maximum) {
    return arc4random_uniform((maximum - minimum) + 1) + minimum;
}

// function with static local variable
int countByTwo() {
    static int currentCount = 0;
    currentCount += 2;
    return currentCount;
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        double angle = PI / 2;              // 1.570795
        NSLog(@"%f", RAD_TO_DEG(angle));    // 90.0
        
        ColorComponent red = 255;
        ColorComponent green = 160;
        ColorComponent blue = 0;
        NSLog(@"Your paint job is (R: %hhu, G: %hhu, B: %hhu)",
              red, green, blue);
        Color carColor = {255, 160, 0};
        NSLog(@"Your paint job is (R: %hhu, G: %hhu, B: %hhu)",
              carColor.red, carColor.green, carColor.blue);
        
        CarModel myCar = NISSAN;
        switch (myCar) {
            case FORD:
            case PORSCHE:
                NSLog(@"You like Western cars?");
                break;
            case HONDA:
            case NISSAN:
                NSLog(@"You like Japanese cars?");
                break;
            default:
                break;
        }
        //ARRAYS
        int years[4] = {1968, 1970, 1989, 1999};
        years[0] = 1967;
        for (int i=0; i<4; i++) {
            NSLog(@"The year at index %d is: %d", i, years[i]);
        }
        
        //POINTERS
        int year = 1967;          // Define a normal variable
        int *pointer;             // Declare a pointer that points to an int
        pointer = &year;          // Find the memory address of the variable
        NSLog(@"%d", *pointer);   // Dereference the address to get its value
        *pointer = 1990;          // Assign a new value to the memory address
        NSLog(@"%d", year);       // Access the value via the variable
        
        char model[5] = {'H', 'o', 'n', 'd', 'a'};
        char *modelPointer = &model[0];
        for (int i=0; i<5; i++) {
            NSLog(@"Value at memory address %p is %c",
                  modelPointer, *modelPointer);
            modelPointer++;
        }
        NSLog(@"The first letter is %c", *(modelPointer - 5));
        
        //NULL POINTER
        int year1 = 1967;
        int *pointer1 = &year1;
        NSLog(@"%d", *pointer1);     // Do something with the value
        pointer1 = NULL;             // Then invalidate it
        
        //POINTERS IN OBJECTIVE-C
        NSString *anObject;    // An Objective-C object
        anObject = NULL;       // This will work
        anObject = nil;        // But this is preferred
        int *aPointer;         // A plain old C pointer
        aPointer = nil;        // Don't do this
        aPointer = NULL;       // Do this instead
        
        //FUNCTION
        int randomNumber = getRandomInteger(-10, 10);
        NSLog(@"Selected a random number between -10 and 10: %d",
              randomNumber);
        NSArray *makes = @[@"Honda", @"Ford", @"Nissan", @"Porsche"];
        NSLog(@"Selected a %@", getRandomMake(makes));
        
        NSArray *makes2 = @[@"Honda", @"Ford", @"Nissan", @"Porsche"];
        NSLog(@"Selected a %@", getRandomMake2(makes2));
        
        //FUNCTION WITH A STATIC LOCAL VARIABLE
        NSLog(@"%d", countByTwo());    // 2
        NSLog(@"%d", countByTwo());    // 4
        NSLog(@"%d", countByTwo());    // 6
        
        
        //Import carutilities.h
        NSDictionary *makesAndModels = @{
                                         @"Ford": @[@"Explorer", @"F-150"],
                                         @"Honda": @[@"Accord", @"Civic", @"Pilot"],
                                         @"Nissan": @[@"370Z", @"Altima", @"Versa"],
                                         @"Porsche": @[@"911 Turbo", @"Boxster", @"Cayman S"]
                                         };
        NSString *randomCar = CUGetRandomMakeAndModel(makesAndModels);
        NSLog(@"Selected a %@", randomCar);
    }
    return 0;
    
    
    
}//END MAIN
 // Implementation
NSString *getRandomMake2(NSArray *makes){
    int maximum = (int)[makes count];
    int randomIndex = arc4random_uniform(maximum);
    return makes[randomIndex];
}



