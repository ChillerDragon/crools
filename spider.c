/* 2019 - ChillerDragon
 * Crap ascii spider generator
 * UNLICESED do what ever you want :)
 *
 * BUILDING:
 * gcc spider.c -o spider
 * ./spider
 */
#include "stdio.h"

// this is the size of the spider
#define MAX_STEPS 20

#define NUM_DIRS 8
#define TILE_FREEZE 9
static const int aaDirections[NUM_DIRS][2] = {
    { 1, 0}, // right
    { 1, 1}, // right down
    { 1,-1}, // right up
    {-1, 0}, // left
    {-1, 1}, // left down
    {-1,-1}, // left up
    { 0, 1}, // down
    { 0,-1}  // up
};

int main()
{
    char aaStepMap[MAX_STEPS*2/*Y*/][MAX_STEPS*2/*X*/];
    for (int y = 0; y < MAX_STEPS*2; y++)
        for (int x = 0; x < MAX_STEPS*2; x++)
            aaStepMap[y][x] = ' ';
    aaStepMap[MAX_STEPS][MAX_STEPS] = 'o';
    for (int dir = 0; dir < NUM_DIRS; dir++)
    {
        for (int step = 1; step < MAX_STEPS; step++)
        {
            int dirX = aaDirections[dir][0];
            int dirY = aaDirections[dir][1];
            int sX = (MAX_STEPS)+(dirX*step);
            int sY = (MAX_STEPS)+(dirY*step);
            // printf("x=%02d y=%02d step=%02d x=%02d y=%02d\n", sX, sY, step, dirX, dirY);
            aaStepMap[sY][sX] = 'x';
        }
    }

    printf("+");
    for (int x = 0; x < MAX_STEPS*2; x++)
        printf("-");
    printf("+\n");
    for (int y = 0; y < MAX_STEPS*2; y++)
    {
        printf("|");
        for (int x = 0; x < MAX_STEPS*2; x++)
            printf("%c", aaStepMap[y][x]);
        printf("|\n");
    }
    printf("+");
    for (int x = 0; x < MAX_STEPS*2; x++)
        printf("-");
    printf("+\n");
    return 0;
}

