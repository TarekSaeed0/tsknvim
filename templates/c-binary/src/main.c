#include <stdio.h>

int main(void) {
	printf("Hello, #{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}#!\n");
}
