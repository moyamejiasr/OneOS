#include "io.h"

/* The I/O ports */
#define FB_COMMAND_PORT         0x3D4
#define FB_DATA_PORT            0x3D5

/* The I/O port commands */
#define FB_HIGH_BYTE_COMMAND    14
#define FB_LOW_BYTE_COMMAND     15

/* FrameBuffer Position */
#define FB_POS                  0x000B8000

/* FrameBuffer Size */
#define FB_ROW                  50 //25
#define FB_COLUMNS              160 //80

enum Color {
  Black, Blue, Green, Cyan,
  Red, Magenta, Brown, Light_grey,
  Dark_grey, Light_blue, Light_green, Light_cyan,
  Light_red, Light_magenta, Light_brown, White 
};

unsigned short fb_r = 0, fb_c = 0;

// Moves the cursor of the framebuffer to the given position
void
fb_move_cursor(unsigned short pos)
{
  outb(FB_COMMAND_PORT, FB_HIGH_BYTE_COMMAND);
  outb(FB_DATA_PORT,    ((pos >> 8) & 0x00FF));
  outb(FB_COMMAND_PORT, FB_LOW_BYTE_COMMAND);
  outb(FB_DATA_PORT,    pos & 0x00FF);
}

// Prints defined chars and move the cursor to the next position.
//
// c is char array with the string to type(must end in \0)
// fg is the foreground color from enum
// bg is the background color from enum
void
fb_print_chars(char* c, unsigned char fg, unsigned char bg)
{
  char *fb = (char *)FB_POS;
  unsigned int i = 0;
  while ( c[i] != 0 ) {
    char isJump = c[i] == '\n';
    if (fb_c >= FB_COLUMNS || isJump) {
        fb_c = 0;
        fb_r++;
        if (isJump) {
          i++;
          continue;
        }
    }
    fb[fb_c++ + (fb_r * FB_COLUMNS)] = c[i++];
    fb[fb_c++ + (fb_r * FB_COLUMNS)] = fg | bg << 4;
    fb_move_cursor(fb_c + (fb_r * (FB_COLUMNS/2)) + 1);
  }
}

void
krnl_main()
{
  fb_print_chars("OneOS init.\nTesting line jump~~\nsecond.\0", White, Black);
  //fb_move_cursor(80);
}
