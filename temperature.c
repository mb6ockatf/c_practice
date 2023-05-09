#include <stdio.h>

// Celsius = (5/9) * (Farenheit - 32)
int main()
{
	int farenheit, celsius, lower, upper, step;
	char farenheit_column[10] = "Farenheit";
	char celsius_column[10] = "Celsius";
	lower = 0;
	upper = 300;
	step = 20;
	farenheit = lower;
	printf("%12s%12s\n", farenheit_column, celsius_column);
	while (farenheit <= upper) {
		celsius = 5 * (farenheit - 32) / 9;
		printf("%12d%8d\n", farenheit, celsius);
		farenheit = farenheit + step;
	}
	return 0;
}
