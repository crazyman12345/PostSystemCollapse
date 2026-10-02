function inventory_has(_item_key, _quantity)
{
    return inventory_get_quantity(_item_key) >= _quantity;
	//true or false if inventory has that quantity
}