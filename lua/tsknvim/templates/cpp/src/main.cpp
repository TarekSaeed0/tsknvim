#include <iostream>

using namespace std;

int main() {
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);

	cout << "Hello, #{in_pascal_case(name):gsub("(%l)(%u)", "%1 %2")}#!\n";
}
