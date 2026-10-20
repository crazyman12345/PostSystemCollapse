function raid_hotbar_use(_slot)
{
    raid_hotbar_validate();
    if (_slot < 0 || _slot >= 6) return false;

    var item = raid.hotbar[_slot];
    if (is_undefined(item)) return false;

    var definition = item_get(item.item_key);
    if (!raid_hotbar_is_usable(definition)) return false;

    if (variable_struct_exists(definition, "treatment_effect"))
    {
        var target = player_health_treatment_get_auto_target(definition);
        if (!is_undefined(target) && player_health_treatment_start(item, target.type, target.limb, _slot)) return true;
        raid.hotbar_feedback_slot = _slot;
        raid.hotbar_feedback_timer = 12;
        raid.hotbar_feedback_success = false;
        return false;
    }

    if (variable_struct_exists(definition, "max_servings"))
    {
        if (player_health_consumable_start(item, _slot)) return true;
        raid.hotbar_feedback_slot = _slot;
        raid.hotbar_feedback_timer = 12;
        raid.hotbar_feedback_success = false;
        return false;
    }

    for (var i = 0; i < array_length(definition.use_effects); i++)
    {
        var effect = definition.use_effects[i];
        if (effect.type == EffectType.HEAL && raid_player_hp >= raid_player_max_hp)
        {
            raid.hotbar_feedback_slot = _slot;
            raid.hotbar_feedback_timer = 12;
            raid.hotbar_feedback_success = false;
            return false;
        }
        if (effect.type == EffectType.ENERGY && player_energy >= health_config.survival_max)
        {
            raid.hotbar_feedback_slot = _slot;
            raid.hotbar_feedback_timer = 12;
            raid.hotbar_feedback_success = false;
            return false;
        }
        if (effect.type == EffectType.HYDRATION && player_hydration >= health_config.survival_max)
        {
            raid.hotbar_feedback_slot = _slot;
            raid.hotbar_feedback_timer = 12;
            raid.hotbar_feedback_success = false;
            return false;
        }
    }

    var hp_before = raid_player_hp;
    raid_apply_effects(definition.use_effects);
    var container = raid_hotbar_find_item(item);
    if (is_undefined(container)) return false;

    item.quantity -= 1;
    save_mark_dirty();
    if (item.quantity <= 0)
    {
        stash_remove_item(item, container);
        raid.hotbar[_slot] = undefined;
    }

    raid.hotbar_feedback_slot = _slot;
    raid.hotbar_feedback_timer = 12;
    raid.hotbar_feedback_success = true;
    if (raid_player_hp > hp_before)
        player_skill_add_xp("vitality", skill_xp_awards.vitality_heal);
    return true;
}
