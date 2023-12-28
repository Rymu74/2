#pragma once

#include <stdint.h>
#include <stddef.h>

void print_clear();
void print_char(char character);
void printf(char* string);
void print_set_color(uint8_t foreground, uint8_t background);