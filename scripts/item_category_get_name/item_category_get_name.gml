function item_category_get_name(_category)
{
    switch (_category)
    {
        case ItemCategory.MATERIAL:
            return "MATERIAL";

        case ItemCategory.LAB_MATERIAL:
            return "LAB MATERIAL";

        case ItemCategory.SEED:
            return "SEED";

        case ItemCategory.PRODUCT:
            return "PRODUCT";

        case ItemCategory.WEAPON:
            return "WEAPON";

        case ItemCategory.AMMO:
            return "AMMUNITION";
			
		case ItemCategory.CURRENCY:
            return "CURRENCY";
    }

    return "UNKNOWN";
}