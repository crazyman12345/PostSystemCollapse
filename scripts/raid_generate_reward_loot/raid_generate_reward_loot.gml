function raid_generate_reward_loot(_reward_type)
{
    var _pool = [];
    var _rolls = 0;

    switch (_reward_type)
    {
        // ============================================================
        // FILING CABINETS
        // ============================================================

        case RaidRewardType.FILING_CABINETS:

            _rolls = irandom_range(1, 2);

            _pool = [
                raid_loot_entry("cash", 45, 10, 35),
                raid_loot_entry("screws", 20, 1, 3),
                raid_loot_entry("bolts", 15, 1, 2),
                raid_loot_entry("plastic", 10, 1, 2),
                raid_loot_entry("broken_radio", 7, 1, 1),
                raid_loot_entry("electronics", 3, 1, 1)
            ];

        break;


        // ============================================================
        // SUPPLY CRATES
        // ============================================================

        case RaidRewardType.SUPPLY_CRATES:

            _rolls = irandom_range(1, 2);

            _pool = [
                raid_loot_entry("cloth", 20, 1, 2),
                raid_loot_entry("leather", 15, 1, 2),
                raid_loot_entry("plastic", 15, 1, 2),
                raid_loot_entry("wood", 15, 1, 2),
                raid_loot_entry("adhesive", 10, 1, 2),
                raid_loot_entry("rubber", 10, 1, 2),
                raid_loot_entry("metal_scrap", 10, 1, 2),
                raid_loot_entry("hiking_pack_junk", 5, 1, 1)
            ];

        break;


        // ============================================================
        // TOOLBOX
        // ============================================================

        case RaidRewardType.TOOLBOX:

            _rolls = irandom_range(1, 2);

            _pool = [
                raid_loot_entry("metal_scrap", 25, 1, 2),
                raid_loot_entry("screws", 20, 1, 2),
                raid_loot_entry("bolts", 15, 1, 2),
                raid_loot_entry("springs", 15, 1, 2),
                raid_loot_entry("mechanical_parts", 10, 1, 1),
                raid_loot_entry("metal_toolbox", 8, 1, 1),
                raid_loot_entry("power_drill", 5, 1, 1),
                raid_loot_entry("precision_parts", 2, 1, 1)
            ];

        break;


        // ============================================================
        // CASH REGISTER
        // ============================================================

        case RaidRewardType.CASH_REGISTER:

            _rolls = irandom_range(1, 2);

            _pool = [
                raid_loot_entry("cash", 75, 25, 75),
                raid_loot_entry("ammo_9mm", 10, 4, 10),
                raid_loot_entry("ammo_45", 7, 3, 7),
                raid_loot_entry("ammo_12g", 5, 2, 5),
                raid_loot_entry("screws", 3, 1, 2)
            ];

        break;


        // ============================================================
        // MEDICAL CRATE
        // ============================================================

        case RaidRewardType.MEDICAL_CRATE:

            _rolls = irandom_range(1, 2);

            _pool = [
                raid_loot_entry("medical_supplies", 30, 1, 2),
                raid_loot_entry("bandage", 20, 1, 1),
                raid_loot_entry("tourniquet", 10, 1, 1),
                raid_loot_entry("splint", 10, 1, 1),
                raid_loot_entry("medkit", 8, 1, 1),
                raid_loot_entry("surgical_kit", 3, 1, 1),
                raid_loot_entry("alcohol", 20, 1, 2),
                raid_loot_entry("painkillers", 15, 1, 1),
                raid_loot_entry("cloth", 10, 1, 3),
                raid_loot_entry("medical_bag", 5, 1, 1)
            ];

        break;


        // ============================================================
        // ELECTRONICS
        // ============================================================

        case RaidRewardType.ELECTRONICS:

            _rolls = irandom_range(1, 2);

            _pool = [
                raid_loot_entry("broken_radio", 25, 1, 1),
                raid_loot_entry("printer", 20, 1, 1),
                raid_loot_entry("electronics", 15, 1, 2),
                raid_loot_entry("plastic", 15, 2, 4),
                raid_loot_entry("mechanical_parts", 10, 1, 1),
                raid_loot_entry("computer", 8, 1, 1),
                raid_loot_entry("precision_parts", 5, 1, 1),
                raid_loot_entry("rare_weapon_parts", 2, 1, 1)
            ];

        break;


        // ============================================================
        // FOOD STORAGE
        // ============================================================

        case RaidRewardType.FOOD_STORAGE:

            _rolls = irandom_range(1, 2);

            _pool = [
                raid_loot_entry("canned_chicken", 14, 1, 1),
                raid_loot_entry("canned_tuna", 14, 1, 1),
                raid_loot_entry("canned_ravioli", 14, 1, 1),
                raid_loot_entry("beef_jerky", 10, 1, 1),
                raid_loot_entry("snickers", 12, 1, 1),
                raid_loot_entry("water_bottle", 14, 1, 1),
                raid_loot_entry("fiji_water", 6, 1, 1),
                raid_loot_entry("diet_coke", 9, 1, 1),
                raid_loot_entry("red_bull", 7, 1, 1)
            ];

        break;


        // ============================================================
        // WEAPON CRATE
        // ============================================================

        case RaidRewardType.WEAPON_CRATE:

            _rolls = irandom_range(1, 2);

            _pool = [
                raid_loot_entry("weapon_parts", 25, 1, 3),
                raid_loot_entry("ammo_9mm", 20, 8, 18),
                raid_loot_entry("ammo_45", 15, 6, 14),
                raid_loot_entry("ammo_12g", 15, 4, 10),
                raid_loot_entry("broken_pistol", 10, 1, 1),
                raid_loot_entry("old_rifle", 6, 1, 1),
                raid_loot_entry("springs", 5, 1, 2),
                raid_loot_entry("m1911", 3, 1, 1),
                raid_loot_entry("double_barrel_shotgun", 1, 1, 1)
            ];

        break;


        // ============================================================
        // ARMOR CRATE
        // ============================================================

        case RaidRewardType.ARMOR_CRATE:

            _rolls = irandom_range(1, 2);

            _pool = [
                raid_loot_entry("cloth", 25, 3, 6),
                raid_loot_entry("leather", 20, 2, 4),
                raid_loot_entry("steel_plate", 15, 1, 1),
                raid_loot_entry("broken_armor", 15, 1, 1),
                raid_loot_entry("adhesive", 10, 1, 2),
                raid_loot_entry("sling_bag", 8, 1, 1),
                //raid_loot_entry("padded_jacket", 4, 1, 1),
               //raid_loot_entry("construction_helmet", 2, 1, 1),
                //raid_loot_entry("school_backpack", 1, 1, 1)
            ];

        break;


        // ============================================================
        // BACKROOM STASH
        // ============================================================

        case RaidRewardType.BACKROOM_STASH:

            _rolls = irandom_range(2, 3);

            _pool = [
                raid_loot_entry("cash", 20, 50, 150),
                raid_loot_entry("weapon_parts", 15, 1, 3),
                raid_loot_entry("medical_supplies", 10, 1, 4),
                raid_loot_entry("electronics", 10, 1, 3),
                raid_loot_entry("steel_plate", 10, 1, 2),
                raid_loot_entry("mechanical_parts", 8, 1, 2),
                raid_loot_entry("precision_parts", 7, 1, 1),
                raid_loot_entry("rare_weapon_parts", 5, 1, 1),

                raid_loot_entry("m1911", 3, 1, 1),
                raid_loot_entry("sling_bag", 2, 1, 1),
                raid_loot_entry("paca", 2, 1, 1),
                raid_loot_entry("construction_helmet", 1, 1, 1),

                raid_loot_entry("old_rifle", 2, 1, 1),
                raid_loot_entry("computer", 2, 1, 1),
                raid_loot_entry("medical_bag", 2, 1, 1),

                raid_loot_entry("ammo_9mm", 1, 12, 24),
                raid_loot_entry("ammo_45", 1, 8, 18),
                raid_loot_entry("ammo_12g", 1, 6, 12)
            ];

        break;
    }


    // ============================================================
    // ROLL LOOT
    // ============================================================

    _pool = raid_loot_filter_weapon_tier(_pool, 1, 10);
    var _loot = [];
	var _scavenging_nodes = skill_node_get_nodes("scavenging");
	var _lucky_looter = skill_node_find(_scavenging_nodes, "lucky_looter");
	var _lucky_looter_unlocked = !is_undefined(_lucky_looter) && skill_node_is_unlocked("scavenging", _lucky_looter);
	var _lucky_looter_2 = skill_node_find(_scavenging_nodes, "lucky_looter_2");
	var _lucky_looter_2_unlocked = !is_undefined(_lucky_looter_2) && skill_node_is_unlocked("scavenging", _lucky_looter_2);

    for (var i = 0; i < _rolls; i++)
    {
        var _entry = raid_loot_pick(_pool);

        var _quantity =
            irandom_range(
                _entry.min_qty,
                _entry.max_qty
            );

		if (_lucky_looter_unlocked || _lucky_looter_2_unlocked)
		{
			var _loot_bonus = (_lucky_looter_unlocked ? 0.05 : 0) + (_lucky_looter_2_unlocked ? 0.05 : 0);
			var _bonus_quantity = _quantity * _loot_bonus;
			_quantity += floor(_bonus_quantity);
			if (random(1) < _bonus_quantity - floor(_bonus_quantity)) _quantity++;
		}

        _loot =
            raid_loot_add(
                _loot,
                _entry.item_key,
                _quantity,
                string(_reward_type)
            );
    }

    return _loot;
}
