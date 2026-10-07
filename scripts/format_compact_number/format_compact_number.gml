function format_compact_number(_amount)
{
    var suffixes = ["", "K", "M", "B", "T", "Qa", "Qi"];
    var suffix_index = 0;
    var compact_amount = abs(_amount);

    while (compact_amount >= 1000 && suffix_index < array_length(suffixes) - 1)
    {
        compact_amount /= 1000;
        suffix_index++;
    }

    var decimal_places = compact_amount < 10 ? 1 : 0;
    var decimal_multiplier = power(10, decimal_places);
    compact_amount = round(compact_amount * decimal_multiplier) / decimal_multiplier;

    if (compact_amount >= 1000 && suffix_index < array_length(suffixes) - 1)
    {
        compact_amount /= 1000;
        suffix_index++;
        decimal_places = 1;
    }

    var amount_text = compact_amount == floor(compact_amount)
        ? string(floor(compact_amount))
        : string_format(compact_amount, 0, decimal_places);

    if (_amount < 0) amount_text = "-" + amount_text;
    return amount_text + suffixes[suffix_index];
}
