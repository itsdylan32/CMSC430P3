// values.h

#ifndef VALUES_H
#define VALUES_H
#include <vector>  // <== Add this line!
#include <string>

int hexToInt(const std::string& hex);              // e.g. #AF2
char escapeChar(const std::string& input);         // e.g. '\n'
int foldLeft(char op, const std::vector<int>& list);
int foldRight(char op, const std::vector<int>& list);

#endif
