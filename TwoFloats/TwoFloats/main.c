//
//  main.c
//  TwoFloats
//
//  Created by Frank Joseph Boccia on 1/17/15.
//  Copyright (c) 2015 Frank Joseph Boccia. All rights reserved.
//

#include <stdio.h>

int main(int argc, const char * argv[]) {
  // Declare the variable called 'weight' of type flpat
    float weight;
    
    // Store a number in that variable
    weight = 42.0;
    
    //Log it to the user
    printf(" The turkey weighs %f.\n",weight);
    
    // Declare another variable
    float height;
    
    height = 5.0 + 18.0 * weight;
    
    printf("height is %f inches.\n", height);
    
    return 0;
           
    
    
}
