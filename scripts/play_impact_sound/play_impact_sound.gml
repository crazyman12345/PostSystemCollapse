function play_impact_sound(_sound, _type)
{
    var pitch_min = 0.92;
    var pitch_max = 1.08;
    var gain_min = 0.85;
    var gain_max = 1.0;

    // ==========================================
    // IMPACT TYPE
    // ==========================================

    switch (_type)
    {
        case "bullet":
            pitch_min = 0.90;
            pitch_max = 1.10;
        break;

        case "knife":
            pitch_min = 0.94;
            pitch_max = 1.06;
        break;
    }

    // ==========================================
    // PLAY SOUND
    // ==========================================

    var snd = audio_play_sound(_sound, 0, false);

    audio_sound_pitch(snd, random_range(pitch_min, pitch_max));
    audio_sound_gain(snd, random_range(gain_min, gain_max), 0);

    return snd;
}