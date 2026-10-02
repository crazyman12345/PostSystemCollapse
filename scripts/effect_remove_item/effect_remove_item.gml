function effect_remove_item(
    _item_key,
    _quantity
)
{
    return {
        type: EffectType.REMOVE_ITEM,

        item_key: _item_key,

        quantity: _quantity
    };
}