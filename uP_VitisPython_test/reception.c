#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define rows 9
#define columns 9

int main(){
    int* TxPacket = (int*)malloc(sizeof(int)*rows*(columns-2)*3);
    int column_counter = 0;
    int element_counter = 0;
    int input[rows*columns] =   {11,12,13,14,15,16,17,18,19, //1th column
                                 21,22,23,24,25,26,27,28,29,
                                 31,32,33,34,35,36,37,38,39,
                                 41,42,43,44,45,46,47,48,49,
                                 51,52,53,54,55,56,57,58,59,
                                 61,62,63,64,65,66,67,68,69,
                                 71,72,73,74,75,76,77,78,79,
                                 81,82,83,84,85,86,87,88,89, 
                                 91,92,93,94,95,96,97,98,99};//last column

    for(int i = 0; i<rows*columns; i++){
        if(column_counter == 0){
            TxPacket[element_counter*3] = input[i];
            element_counter++;
        }
        else if(column_counter == 1){
            TxPacket[(element_counter*3)+1] = input[i];
            TxPacket[(element_counter*3)+rows*3] = input[i];
            element_counter++;
        }
        else if(column_counter == columns-1){
            TxPacket[(element_counter*3)+(3*rows*(columns-3)+2)] = input[i];
            element_counter++;
        }
        else if(column_counter == columns-2){
            TxPacket[(element_counter*3)+(3*rows*(columns-4))+2] = input[i];
            TxPacket[(element_counter*3)+(3*rows*(columns-3))+1] = input[i];
            element_counter++;
        }
        else{
            TxPacket[(element_counter*3)+(3*rows*(column_counter-2))+2] = input[i];
            TxPacket[(element_counter*3)+(3*rows*(column_counter-1))+1] = input[i];
            TxPacket[(element_counter*3)+(3*rows*column_counter)] = input[i];
            element_counter++;
        }

        if(element_counter == rows){
            column_counter++;
            element_counter = 0;
        }
    }

    for(int i = 0; i<rows*(columns-2)*3; i++){
        printf("%d\n", TxPacket[i]);
    }

    return 0;
}