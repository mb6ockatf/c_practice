#include <stdio.h>

int main()
{
	int character, lines;
	lines = 0;
	while ((character = getchar()) != EOF)
		if (character == '\n')
			++lines;
	printf("%d\n", lines);
	return 0;
}
