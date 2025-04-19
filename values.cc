// values.cc

#include "values.h"
#include <stdexcept>
#include <sstream>
#include <cctype>
#include <iostream>
#include <vector>
#include <cmath>

int hexToInt(const std::string& hex) {
    int value;
    std::stringstream ss;
    ss << std::hex << hex.substr(1); // Skip '#' symbol
    ss >> value;
    return value;
}

char escapeChar(const std::string& input) {
    if (input.length() == 3) return input[1];  // Normal char: 'a'
    if (input.length() == 4 && input[1] == '\\') {
        switch (input[2]) {
            case 'n': return '\n';
            case 't': return '\t';
            case 'r': return '\r';
            case '0': return '\0';
            case '\\': return '\\';
            case '\'': return '\'';
            case '\"': return '\"';
            case 'f': return '\f';
            default: return '?'; // Unknown escape
        }
    }
    return '?'; // Malformed
}

int foldLeft(char op, const std::vector<int>& list) {
    if (list.empty()) throw std::runtime_error("Empty list for foldLeft");
    int result = list[0];
    for (size_t i = 1; i < list.size(); ++i) {
        switch (op) {
            case '+': result += list[i]; break;
            case '-': result -= list[i]; break;
            case '*': result *= list[i]; break;
            case '/': result /= list[i]; break;
            case '%': result %= list[i]; break;
            default: throw std::runtime_error("Unsupported operator");
        }
    }
    return result;
}

int foldRight(char op, const std::vector<int>& list) {
    if (list.empty()) throw std::runtime_error("Empty list for foldRight");
    int result = list.back();
    for (int i = list.size() - 2; i >= 0; --i) {
        switch (op) {
            case '+': result = list[i] + result; break;
            case '-': result = list[i] - result; break;
            case '*': result = list[i] * result; break;
            case '/': result = list[i] / result; break;
            case '%': result = list[i] % result; break;
            default: throw std::runtime_error("Unsupported operator");
        }
    }
    return result;
}
