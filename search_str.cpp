#include <string>
#include <algorithm>
#include <iostream>

int main(int ac, char **av)
{
	std::string str = av[1];

	for (int i = 0; i < str.size(); i++)
	{
		str[i] = tolower(str[i]);
	} 
	std::cout << str << std::endl;

	if (str.find("admin") != std::string::npos)
		return 1;
	return 0;
}
