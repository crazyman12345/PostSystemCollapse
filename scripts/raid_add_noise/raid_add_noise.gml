function raid_add_noise(_amount)
{
    raid.noise +=
        _amount;

    raid.noise =
        max(
            0,
            raid.noise
        );


    raid_update_threat();
}