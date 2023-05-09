#include <stdio.h>
#define IN 1
#define OUT 0

int main()
{
	int state, character, wordcounter, linecounter, charactercounter;
	linecounter = wordcounter = charactercounter = 0;
	while ((character = getchar()) != EOF) {
		++charactercounter;
		if (character == '\n') {
			++linecounter;
		}
		else if (character == ' ' || character == '\n' || character == '\t') {
			state = IN;
			++wordcounter;
		}
	}
	printf("%d %d %d\n", linecounter, wordcounter, charactercounter);
	return 0;
}
