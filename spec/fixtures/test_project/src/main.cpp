#include <iostream>

#include "data/data.h"

int main(int argc, char** argv)
{
	Data data("Hello, World!");
	std::cout << data.data() << std::endl;
	return 0;
}