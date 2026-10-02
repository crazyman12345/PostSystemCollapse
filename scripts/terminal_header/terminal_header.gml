function terminal_header(_title)
{
	draw_set_font(fnt_terminal);
    var left = 80;
    var right = 1840;
    var top = 20;

    draw_text(left, top, "==============================================================================================");

    draw_set_halign(fa_center);
    draw_text(960, top + 45, _title);
    draw_set_halign(fa_left);

    draw_text(left, top + 90, "==============================================================================================");
}