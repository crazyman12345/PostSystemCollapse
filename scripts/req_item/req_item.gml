function req_item(
    _item_key,
    _quantity
)
{
    return {
        type: RequirementType.ITEM,

        item_key: _item_key,

        quantity: _quantity
    };
}