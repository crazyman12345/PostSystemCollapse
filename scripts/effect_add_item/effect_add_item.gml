function effect_add_item(
    _item_key,
    _quantity
)
{
    return {
        type: EffectType.GIVE_ITEM,

        item_key: _item_key,

        quantity: _quantity
    };
}