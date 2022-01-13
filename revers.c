/*
 * Copyright 1991-2015 Mentor Graphics Corporation
 *
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
 * LICENSE TERMS.
 *
 * Simple SystemVerilog DPI Example - C function to compute sum of digits of a number.
 */
#include "revers.h"

int countN(int data)
{
    if(data>9999){
        return 5;
    }
    else if (data>999){
        return 4;
    }
    else if (data>99){
        return 3;
    }
    else if (data>9){
        return 2;
    }
    else{
        return 1;
    }
}

int stp(int N)
{
    switch (N){
        case 1: return 10;
        case 2: return 100;
        case 3: return 1000;
        case 4: return 10000;
        case 5: return 100000;
    }
    return 1;
}

int revers(int data, int N)
{
    return N == 1 ? (data) : (revers(data % stp(N-1), N-1)*10 + (data / stp(N-1)));
}
