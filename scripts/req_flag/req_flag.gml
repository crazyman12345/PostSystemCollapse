function req_flag(_flag_key, _value = true)
{
    return {
        type: RequirementType.FLAG,
        flag_key: _flag_key,
        value: _value
    };
}