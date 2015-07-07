//
//  main.c
//  Turkey
//
//  Created by Frank Joseph Boccia on 1/17/15.
//  Copyright (c) 2015 Frank Joseph Boccia. All rights reserved.
//

#include <stdio.h> 

int main (int argc, const char * argv[])
{
    // Declare the variable called 'weight' of type float
    float weight;
    
    // Store a number in that variable
    weight = 14.2;
    
    // log it to the user
    printf(" The Turkey weighs %f.\n", weight);
    
    // Declare another variable of type float
    float cookingTime;
    
    // Claculate the cooking time and store it in the variable
    // In this case, '*' mean 'multiplied by'
    cookingTime = 15.0 + 15.0 * weight;
    
    // Log that to the user
    printf("Cook it for %f minutes.\n", cookingTime);
    
    //End this function and indicate success
    return 0; 
    
  


}
