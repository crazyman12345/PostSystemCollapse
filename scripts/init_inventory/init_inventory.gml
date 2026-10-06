function init_inventory()
{
    inventory = {};
    init_stash();
    // Starting inventory for testing
    inventory_add("ammo_9mm", 75);
    inventory_add("pipe_pistol", 1);
	inventory_add("cash", 10000);
	inventory_add("bandage", 5);
	inventory_add("sling_bag", 1);
}
