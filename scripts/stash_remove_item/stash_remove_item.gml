function stash_remove_item(_item, _container = stash)
{
    for (var i = 0; i < array_length(_container.items); i++)
    {
        if (_container.items[i] == _item)
        {
            array_delete(_container.items, i, 1);
            return true;
        }
    }

    return false;
}
