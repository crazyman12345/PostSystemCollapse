function morrowleaf_fail()
{
    grow_active = false;
    grow_fail_reason = "PROLONGED NEGLECT";
	log_add("Morrowleaf grow failed from neglect.");
    drug_state = DrugState.MORROWLEAF_FAIL;
    menu_index = 0;
}