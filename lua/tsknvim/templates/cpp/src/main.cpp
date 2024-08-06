#include <iostream>

int main() {
	std::cout << "Hello, #{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}#!\n";
}
