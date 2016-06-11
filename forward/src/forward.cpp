#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include "minterm.h"

using namespace std;
#define statmax 256
#define powermax 8

char bintable[statmax+1][powermax+1];

int get_power(int stat_num , int power)
{
    //if stat_num isn't 2^n, for example, stat_num = 5, then let power be 3, and input 6~8 will be 0 initially.
    int two_power = 1;
    while(two_power < stat_num)
    {
        two_power *= 2;
        power++;
    }
    return power;
}

void build_bintable(int stat_num, int power)
{
    memset(bintable, 0, sizeof(char) * (statmax + 1) * (powermax + 1));
    for(int i = 0; i < stat_num; i++)
    {
        int j = power - 1, num = i;
        while(num > 0)
        {
            bintable[i][j] = (num % 2 == 0 ? '0':'1');
            j --;
            num /= 2;
        }
        while(j >= 0)
        {
            bintable[i][j] = '0';
            j--;
        }
    }
}


void bin_to_stat(char stat_table[statmax+1][powermax+1], int table[statmax][4], int stat_num, int power)
{
    for(int i = 0 ; i < stat_num ; i++)
    {
        strncpy(stat_table[i], bintable[(table[i][0])], power);
        strncpy(stat_table[i] + power, bintable[(table[i][1])], power);
    }
}

//For D,T flipflop
void build_kmap_DT(char kmap[statmax][2], char stat_table[statmax+1][powermax+1], char fftype,
                int power, int i, int stat_num)
{
    if(fftype == 'D')
    {
        for(int j = 0 ; j < stat_num ; j++)
        {
            kmap[j][0] = stat_table[j][i];
            kmap[j][1] = stat_table[j][i + power];
        }
    }
    else
    {
        for(int j = 0 ; j < stat_num ; j++)
        {
            int tmp = bintable[j][i] - '0';
            kmap[j][0] = ( tmp ^ (stat_table[j][i] - '0') == 1? '1':'0');
            kmap[j][1] = ( tmp ^ (stat_table[j][i + power] - '0') == 1? '1':'0');
        }
    }
}
void build_kmap_JS(char kmap1[statmax][2], char kmap2[statmax][2], char stat_table[statmax+1][powermax+1], char fftype,
                int power, int i, int stat_num)
{
    if(fftype == 'J')
    {
        for(int j = 0 ; j < stat_num ; j++)
        {
            if(bintable[j][i] == '1')
            {
                kmap1[j][0] = 'd';
                kmap1[j][1] = 'd';
            }
            else
            {
                kmap1[j][0] = stat_table[j][i];
                kmap1[j][1] = stat_table[j][i + power];
            }
            if(bintable[j][i] == '0')
            {
                kmap2[j][0] = 'd';
                kmap2[j][1] = 'd';
            }
            else
            {
                kmap2[j][0] = (stat_table[j][i] == '0'? '1':'0');
                kmap2[j][1] = (stat_table[j][i + power] == '0'? '1':'0');
            }
        }
    }
    else
    {
        for(int j = 0 ; j < stat_num ; j++)
        {
            if(bintable[j][i] == '0')
            {
                kmap1[j][0] = stat_table[j][i];
                kmap1[j][1] = stat_table[j][i + power];

                kmap2[j][0] = (stat_table[j][i] == '0'? 'd':'0');
                kmap2[j][1] = (stat_table[j][i + power] == '0' ? 'd':'0');
            }
            else
            {
                kmap1[j][0] = (stat_table[j][i] == '0'? '0':'d');
                kmap1[j][1] = (stat_table[j][i + power] == '0'? '0':'d');

                kmap2[j][0] = (stat_table[j][i] == '0'? '1':'0');
                kmap2[j][1] = (stat_table[j][i + power] == '0'? '1':'0');
            }
        }
    }
}

void build_qm_file(char kmap[statmax][2], int power, int stat_num)
{
    int termNum = 0;
    for(int i = 0 ; i < stat_num ; i++){
        for(int j = 0 ; j < 2 ; j++){
            if(kmap[i][j] != '0') termNum ++;
        }
    }
    fstream fs("tmp", fstream::out | fstream::trunc);
    fs << power + 1 << endl;
    fs << termNum << endl;
    for(int i = 0 ; i < 2 ; i++)
        for(int j = 0 ; j < stat_num ; j++)
            if(kmap[j][i] != '0')
                    fs << i << bintable[j] << " " << kmap[j][i] << endl;
    fs.flush();
    fs.close();
}


void get_qm_res(const char* out) {
    ifstream qm_out("qm_out");
    string qm_res;
    getline(qm_out, qm_res);
    printf("%s = %s\n", out, qm_res.c_str());
    qm_out.close();
}

int main(void)
{
    printf("DSDL_2016 Final Project : Forward Design\n\n");
    int type; // true means mealy machine , moore otherwise
    int stat_num, input_table[statmax][4] = {0};
    //input format equals to example code
    printf("Enter the type of state machine:(0 for moore;1 for mealy)\n");
    scanf("%d", &type);
    printf("Enter the number of states:\n");
    scanf("%d", &stat_num);
    int power = 0;
    if(stat_num < 2 || stat_num > statmax)
    {
        printf("%d is smaller than 2 or larger than %d\n", stat_num, statmax);
        return -1;
    }
    power = get_power(stat_num, power);
    printf("Enter the state input table:\n");
    for(int i = 0 ; i < stat_num ; i++)
        scanf("%d %d %d %d", &input_table[i][0],&input_table[i][1],&input_table[i][2],&input_table[i][3]);

    build_bintable(stat_num, power);

    //set flip-flop type.
    //Type: D, T, J(K), S(R)
    printf("Enter the type of flip-flops:\n");
    char fftype[powermax];
    scanf("%s", fftype);

    char stat_table[statmax + 1][powermax + 1];
    memset(stat_table, 0, sizeof(char) * (statmax + 1) * (powermax + 1) );
    bin_to_stat(stat_table, input_table, stat_num, power);
    printf("-----------------------------\n");
    printf("Binary State Transition Table\n");
    printf("input       0 1\n");
    for(int i = 0 ; i < stat_num ; i++)
        printf("state %s | %s\n", bintable[i], stat_table[i]);
    printf("-----------------------------\n");
    
    printf("Output Table\n");
    printf("input      0 | 1\n");
    char out_kmap[statmax][2];
    for(int i = 0; i < stat_num; i++)
    {
        out_kmap[i][0] = input_table[i][2] == 1 ?'1':'0';
        out_kmap[i][1] = input_table[i][3] == 1 ?'1':'0';
        printf("state %s | %c | %c\n", bintable[i], out_kmap[i][0], out_kmap[i][1]);
    }
    build_qm_file(out_kmap, power, stat_num);
    qm("tmp");
    get_qm_res("out");
    printf("-----------------------------\n");
    
    for(int i = 0 ; i < power ; i++)
    {
        printf("Flipflop%d: %c-flipflop K-map\n", i, fftype[i]);
        if(fftype[i] == 'D' || fftype[i] == 'T')
        {
            char kmap[statmax][2];
            build_kmap_DT(kmap, stat_table, fftype[i], power, i, stat_num);
            printf("input      0 | 1\n");
            for(int j = 0 ; j < stat_num; j++)
                printf("state %s | %c | %c\n", bintable[j], kmap[j][0], kmap[j][1]);\
            build_qm_file(kmap, power, stat_num);
            qm("tmp");
            get_qm_res(&fftype[i]);
        }
        else
        {
            char kmap1[statmax][2], kmap2[statmax][2];
            build_kmap_JS(kmap1, kmap2, stat_table, fftype[i], power, i, stat_num);
            printf("input       0 |  1\n");
            for(int j = 0 ; j < stat_num ; j++)
                printf("state %s | %c%c | %c%c\n", bintable[j], kmap1[j][0], kmap2[j][0], kmap1[j][1], kmap2[j][1]);
            build_qm_file(kmap1, power, stat_num);
            qm("tmp");
            (fftype[i] == 'S') ? get_qm_res("S") : get_qm_res("J");
            build_qm_file(kmap2, power, stat_num);
            qm("tmp");
            (fftype[i] == 'S') ? get_qm_res("R") : get_qm_res("K");
        }
        printf("-----------------------------\n");
    }
    if(remove("tmp") != 0 || remove("qm_out") != 0)
        printf("Fail to delete file\n");
    return 0;
}