#include <stdio.h>

int main(void) {
	printf("Hello, #{name:to_pascal_case():gsub("(%l)(%u)", "%1 %2")}#!\n");
}
