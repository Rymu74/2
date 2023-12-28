#include "print.h"

const static size_t COLS = 80;
const static size_t ROWS = 25;

struct Char {
    uint8_t character;
    uint8_t color;
};

struct Char* buffer = (struct Char*) 0xb8000;
size_t col = 0;
size_t row = 0;
uint8_t color = 15 | 0 << 4;

void clear_row(size_t row) {
    struct Char empty = (struct Char) {
        character: ' ',
        color: color,
    };

    for (size_t col = 0; col < COLS; col++) {
        buffer[col + COLS * row] = empty;
    }
}

void print_clear() {
    for (size_t i = 0; i < ROWS; i++) {
        clear_row(i);
    }
}

void print_newline() {
    col = 0;

    if (row < ROWS - 1) {
        row++;
        return;
    }

    for (size_t row = 1; row < ROWS; row++) {
        for (size_t col = 0; col < COLS; col++) {
            struct Char character = buffer[col + COLS * row];
            buffer[col + COLS * (row - 1)] = character;
        }
    }
    clear_row(COLS - 1);
}

void print_char(char character) {
    if (character == '\n') {
        print_newline();
    }

    if (col > COLS) {
        print_newline();
    }

    buffer[col + COLS * row] = (struct Char) {
        character: (uint8_t) character,
        color: color,
        };

        col++;
}

void printf(char* str) {
    for (size_t i = 0; 1; i++) {
        char character = (uint8_t) str[i];

        if (character == '\0') {
            return;
        }
        print_char(character);
        }
}

void print_set_color(uint8_t foreground, uint8_t background) {
    color = foreground + (background << 4);
}