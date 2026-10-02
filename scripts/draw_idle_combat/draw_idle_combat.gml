function draw_idle_combat(_enemy_key)
{
    var enemy = enemy_get(_enemy_key);
    if (is_undefined(enemy)) return;

    draw_set_font(fnt_terminal_small);
    draw_set_color(c_lime);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    // ==========================================
    // MAIN LAYOUT
    // ==========================================

    var content_left = 320;
    var content_top = 80;
    var content_height = 1000;

    var player_width = 900;
    var enemy_width = 700;

    var player_left = content_left;
    var enemy_left = content_left + player_width;

    terminal_panel(player_left, content_top, player_width, content_height, "PLAYER");
    terminal_panel(enemy_left, content_top, enemy_width, content_height, "ENEMY");

    // ==========================================
    // PLAYER HEALTH
    // ==========================================

    var player_health_bar = ascii_bar(idle_combat_player_hp, idle_combat_player_max_hp, 24);

    draw_text(player_left + 30, content_top + 55, "HEALTH");
    draw_text(player_left + 30, content_top + 90, player_health_bar);
    draw_text(player_left + 30, content_top + 125, string(idle_combat_player_hp) + " / " + string(idle_combat_player_max_hp));

    // ==========================================
    // PLAYER ATTACK COOLDOWN
    // ==========================================

    var player_attack_bar = ascii_bar(idle_combat_player_attack_timer, idle_combat_player_attack_interval, 24);

    draw_text(player_left + 30, content_top + 160, "ATTACK");
    draw_text(player_left + 30, content_top + 195, player_attack_bar);

    draw_text(
        player_left + 30,
        content_top + 230,
        string_format(idle_combat_player_attack_timer, 1, 1)
        + " / "
        + string_format(idle_combat_player_attack_interval, 1, 1)
        + " SEC"
    );

    // ==========================================
    // MEDS BOX
    // ==========================================

    var meds_left = player_left + 30;
    var meds_top = content_top + 280;
    var meds_width = 360;
    var meds_height = 180;

    var meds_title = "MEDS";

    if (idle_combat_box == IdleCombatBox.MEDS)
        meds_title = "> MEDS <";

    terminal_panel(meds_left, meds_top, meds_width, meds_height, meds_title);

    draw_text(meds_left + 25, meds_top + 60, "NO MED SELECTED");

    if (idle_combat_box == IdleCombatBox.MEDS && idle_combat_in_box)
        draw_text(meds_left + 25, meds_top + 110, "[W/S] SELECT   [ENTER] USE   [ESC] BACK");

    // ==========================================
    // EQUIPMENT BOX
    // ==========================================

    var equipment_left = player_left + 30;
    var equipment_top = content_top + 480;
    var equipment_width = 360;
    var equipment_height = 390;

    var equipment_title = "EQUIPMENT";

    if (idle_combat_box == IdleCombatBox.EQUIPMENT)
        equipment_title = "> EQUIPMENT <";

    terminal_panel(equipment_left, equipment_top, equipment_width, equipment_height, equipment_title);

    draw_text(equipment_left + 25, equipment_top + 60,  "HEAD      -");
    draw_text(equipment_left + 25, equipment_top + 105, "BODY      -");
    draw_text(equipment_left + 25, equipment_top + 150, "WEAPON    -");
    draw_text(equipment_left + 25, equipment_top + 195, "BAG       -");

    if (idle_combat_box == IdleCombatBox.EQUIPMENT && idle_combat_in_box)
        draw_text(equipment_left + 25, equipment_top + 310, "[W/S] SELECT   [ENTER] EQUIP   [ESC] BACK");

    // ==========================================
    // PLAYER PORTRAIT
    // ==========================================

    var portrait_left = player_left + 420;
    var portrait_top = content_top + 55;
    var portrait_width = 440;
    var portrait_height = 330;

    terminal_box(portrait_left, portrait_top, portrait_width, portrait_height);

    var player_sprite = player_spr;

    if (player_sprite != -1)
    {
        draw_sprite_stretched(player_sprite, 0, portrait_left + 5, portrait_top + 5, portrait_width - 10, portrait_height - 10);
    }
    else
    {
        draw_set_halign(fa_center);
        draw_text(portrait_left + portrait_width / 2, portrait_top + portrait_height / 2 - 15, "-1");
        draw_set_halign(fa_left);
    }

    // ==========================================
    // PLAYER STATS
    // ==========================================

    var stats_left = player_left + 420;
    var stats_top = content_top + 405;
    var stats_width = 440;
    var stats_height = 260;

    terminal_panel(stats_left, stats_top, stats_width, stats_height, "STATS");

    draw_text(stats_left + 25, stats_top + 55, "MIN DAMAGE      " + string(idle_combat_player_min_damage));
    draw_text(stats_left + 25, stats_top + 90, "MAX DAMAGE      " + string(idle_combat_player_max_damage));
    draw_text(stats_left + 25, stats_top + 125, "ACCURACY        " + string(idle_combat_player_accuracy) + "%");
    draw_text(stats_left + 25, stats_top + 160, "CRIT CHANCE     " + string(idle_combat_player_crit_chance) + "%");
    draw_text(stats_left + 25, stats_top + 195, "CRIT DAMAGE     " + string(idle_combat_player_crit_damage) + "%");

    // ==========================================
    // COMBAT TACTIC
    // ==========================================

    var tactic_left = player_left + 420;
    var tactic_top = content_top + 685;
    var tactic_width = 440;
    var tactic_height = 185;

    var tactic_title = "COMBAT TACTIC";

    if (idle_combat_box == IdleCombatBox.TACTIC)
        tactic_title = "> COMBAT TACTIC <";

    terminal_panel(tactic_left, tactic_top, tactic_width, tactic_height, tactic_title);

    var offensive_text = "  OFFENSIVE";
    var mixed_text = "  MIXED";
    var defensive_text = "  DEFENSIVE";

    if (combat_tactic == CombatTactic.OFFENSIVE) offensive_text = "> OFFENSIVE <";
    if (combat_tactic == CombatTactic.MIXED) mixed_text = "> MIXED <";
    if (combat_tactic == CombatTactic.DEFENSIVE) defensive_text = "> DEFENSIVE <";

    draw_text(tactic_left + 25, tactic_top + 55, offensive_text);
    draw_text(tactic_left + 25, tactic_top + 90, mixed_text);
    draw_text(tactic_left + 25, tactic_top + 125, defensive_text);

    // ==========================================
    // BACK BUTTON
    // ==========================================

    var back_left = player_left + 30;
    var back_top = content_top + 890;
    var back_width = 830;
    var back_height = 70;

    terminal_box(back_left, back_top, back_width, back_height);

    var back_text = "BACK TO AREA SELECT";

    if (idle_combat_box == IdleCombatBox.BACK)
        back_text = "> BACK TO AREA SELECT <";

    draw_set_halign(fa_center);
    draw_text(back_left + back_width / 2, back_top + 23, back_text);
    draw_set_halign(fa_left);

    // ==========================================
    // ENEMY HEALTH
    // ==========================================

    var enemy_health_bar = ascii_bar(idle_combat_enemy_hp, enemy.max_hp, 30);

    draw_text(enemy_left + 30, content_top + 55, enemy.name);
    draw_text(enemy_left + 30, content_top + 90, "HEALTH");
    draw_text(enemy_left + 30, content_top + 125, enemy_health_bar);
    draw_text(enemy_left + 30, content_top + 160, string(idle_combat_enemy_hp) + " / " + string(enemy.max_hp));

    // ==========================================
    // ENEMY ATTACK COOLDOWN
    // ==========================================

    var enemy_attack_bar = ascii_bar(idle_combat_enemy_attack_timer, idle_combat_enemy_attack_interval, 30);

    draw_text(enemy_left + 30, content_top + 200, "ATTACK");
    draw_text(enemy_left + 30, content_top + 235, enemy_attack_bar);

    draw_text(
        enemy_left + 30,
        content_top + 270,
        string_format(idle_combat_enemy_attack_timer, 1, 1)
        + " / "
        + string_format(idle_combat_enemy_attack_interval, 1, 1)
        + " SEC"
    );

    // ==========================================
    // ENEMY IMAGE
    // ==========================================

    var enemy_image_left = enemy_left + 120;
    var enemy_image_top = content_top + 320;
    var enemy_image_width = enemy_width - 240;
    var enemy_image_height = 330;

    terminal_box(enemy_image_left, enemy_image_top, enemy_image_width, enemy_image_height);

    if (enemy.sprite != -1)
    {
        draw_sprite_stretched(enemy.sprite, 0, enemy_image_left + 5, enemy_image_top + 5, enemy_image_width - 10, enemy_image_height - 10);
    }
    else
    {
        draw_set_halign(fa_center);
        draw_text(enemy_image_left + enemy_image_width / 2, enemy_image_top + enemy_image_height / 2 - 15, "-1");
        draw_set_halign(fa_left);
    }

    // ==========================================
    // ENEMY STATS
    // ==========================================

    var enemy_stats_left = enemy_left + 30;
    var enemy_stats_top = content_top + 670;
    var enemy_stats_width = enemy_width - 60;
    var enemy_stats_height = 290;

    terminal_panel(enemy_stats_left, enemy_stats_top, enemy_stats_width, enemy_stats_height, "ENEMY STATS");

    draw_text(enemy_stats_left + 25, enemy_stats_top + 55, "LEVEL           " + string(enemy.level));
    draw_text(enemy_stats_left + 25, enemy_stats_top + 95, "MIN DAMAGE      " + string(enemy.min_damage));
    draw_text(enemy_stats_left + 25, enemy_stats_top + 135, "MAX DAMAGE      " + string(enemy.max_damage));
    draw_text(enemy_stats_left + 25, enemy_stats_top + 175, "ACCURACY        " + string(enemy.accuracy) + "%");
    draw_text(enemy_stats_left + 25, enemy_stats_top + 215, "ATTACK SPEED    " + string(enemy.attack_interval) + " SEC");

    draw_set_font(fnt_terminal);
}