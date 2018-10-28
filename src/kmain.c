
enum Color {    Black, Blue, Green, Cyan,
                Red, Magenta, Brown, Light_grey,
                Dark_grey, Light_blue, Light_green, Light_cyan,
                Light_red, Light_magenta, Light_brown, White 
            };

int fb_loc = 0;
char *fb = (char *)0x000B8000;

void fb_print_chars(char* c, unsigned char fg, unsigned char bg)
{
    unsigned int i = 0;
    while ( c[i] != 0 ) {
        fb[fb_loc++] = c[i++];
        fb[fb_loc++] = ((fg & 0x0F) << 4) | (bg & 0x0F);
    }
}

void krnl_main()
{
    fb_print_chars("OneOS init.\0", Black, White);
}