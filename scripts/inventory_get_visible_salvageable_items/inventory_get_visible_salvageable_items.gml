function inventory_get_visible_salvageable_items()
{
	var _items = inventory_get_visible_items();
	var _salvageable = [];

	for (var i = 0; i < array_length(_items); i++)
	{
		var _item_key = _items[i];

		if (item_can_salvage(_item_key))
		{
			array_push(_salvageable, _item_key);
		}
	}

	return _salvageable;
}