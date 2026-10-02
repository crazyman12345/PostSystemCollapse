function effect_flag(_flag_key, _value = true)
{
    return {
        type: EffectType.SET_FLAG,
        flag_key: _flag_key,
        value: _value
    };
}