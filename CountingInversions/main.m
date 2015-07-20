//
//  main.m
//  CountingInversions
//
//  Created by Abhi on 7/19/15.
//  Copyright (c) 2015 ___Abhishek Moothedath___. All rights reserved.
//

#import <Foundation/Foundation.h>

NSArray *merge(NSArray *leftArray, NSArray *rightArray, NSUInteger *inversions)
{
    NSMutableArray *merged = [NSMutableArray new];
    NSUInteger leftArrayPointer = 0, rightArrayPointer = 0;
    
    for(NSUInteger i = 0; i < leftArray.count + rightArray.count; i++)
    {
        if(leftArrayPointer >= leftArray.count)
        {
            [merged addObject:[rightArray objectAtIndex:rightArrayPointer++]];
            continue;
        }
        if(rightArrayPointer >= rightArray.count)
        {
            [merged addObject:[leftArray objectAtIndex:leftArrayPointer++]];
            continue;
        }
        
        if([leftArray objectAtIndex:leftArrayPointer] <= [rightArray objectAtIndex:rightArrayPointer])
            [merged addObject:[leftArray objectAtIndex:leftArrayPointer++]];
        else
        {
            [merged addObject:[rightArray objectAtIndex:rightArrayPointer++]];
            *inversions = *inversions + (leftArray.count - leftArrayPointer);
        }
    }
    return merged;
}

NSArray* subdivision(NSArray *numbers, NSUInteger *inversions)
{
    if(numbers.count == 1)
    {
        return [numbers copy];
    }
    else
    {
        NSArray *leftArray = [numbers subarrayWithRange:NSMakeRange(0, numbers.count / 2)];
        NSArray *rightArray = [numbers subarrayWithRange:NSMakeRange(numbers.count / 2, numbers.count - numbers.count / 2)];
    
        NSArray *sortedLeft = subdivision(leftArray, inversions);
        NSArray *sortedRight = subdivision(rightArray, inversions);
        
        return merge(sortedLeft, sortedRight, inversions);
    }
}

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NSError *error;
        NSURL *url = [[NSURL alloc] initFileURLWithPath:@"File.txt"];
        NSString *unsortedNumbersString = [[NSString alloc] initWithContentsOfURL:url
                                                                         encoding:NSUTF8StringEncoding error:&error];
        NSArray *unsortedNumbersStringArray = [unsortedNumbersString
                                               componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSMutableArray *numbers = [NSMutableArray new];

        NSNumberFormatter *formatter = [NSNumberFormatter new];
        for(NSString *numberString in unsortedNumbersStringArray)
        {
            if([numberString isEqualTo:@""] == NO)
                [numbers addObject: [formatter numberFromString:numberString]];
        }
        NSArray *leftArray = [numbers subarrayWithRange:NSMakeRange(0, numbers.count / 2)];
        NSArray *rightArray = [numbers subarrayWithRange:NSMakeRange(numbers.count / 2, numbers.count - numbers.count / 2)];
        
        NSUInteger inversions = 0;
        NSDate *currentTime = [NSDate date];
        NSArray *sortedLeft = subdivision(leftArray, &inversions);
        NSArray *sortedRight = subdivision(rightArray, &inversions);
        
        merge(sortedLeft, sortedRight, &inversions);
        double timeElapsed = -[currentTime timeIntervalSinceNow];
        NSLog(@"number of inversions is %li. Time taken to compute inversions for %li objects is %f", inversions, numbers.count, timeElapsed);
    }

    return 0;
}
