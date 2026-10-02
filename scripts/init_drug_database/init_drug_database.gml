global.drugs = {};

global.drugs.morrowleaf = {
    drug_key : "morrowleaf",
    name : "Morrowleaf",

    required_level : 1,
    duration : 60,

    minigame_type : DrugMinigameType.CULTIVATION,

    input_item : "morrowleaf_grow_kit",
    output_item : "raw_morrowleaf",

    base_yield : 3,
    base_xp : 15
};

//this is just a placeholder, eventually when adding other drugs, make generic scripts
//to handle all drugs and make this database hold all the info for the drugs to make
//system clean and organized