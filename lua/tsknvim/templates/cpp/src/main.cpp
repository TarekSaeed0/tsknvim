#include <iostream>

using namespace std;

int main() {
	cout << "Hello, #{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}#!\n";
}
