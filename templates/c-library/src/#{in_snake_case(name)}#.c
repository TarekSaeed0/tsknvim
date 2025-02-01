#include <#{in_snake_case(name)}#.h>

#include <stdio.h>

void #{in_snake_case(name)}#_hello(void) {
	printf("Hello, #{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}#!\n");
}
