// File: arc_ngev.mod					
// Author: Marcelo Simas Oliveira (Westat), with input from Peter Vovsha (PB)					
// Date: February 1st 2013					
					
[ModelDescription]					
Trip purpose nested logit model					
					
[Choice]					
apurp					
					
[Beta]					
// Name Value  LowerBound UpperBound  status (0=variable, 1=fixed)					
//name	value	lb	up	status	
// person specific betas					
// purpose specific betas					
// tree specific betas					
asc_cra_lu_institutional	0	-1.00E+04	1.00E+04	0	
asc_cra_nearchurch	0	-1.00E+04	1.00E+04	0	
asc_ctm_iswalkorwheelchair	0	-1.00E+04	1.00E+04	0	
asc_ctm_transfervariableatleastonenonauto	0	-1.00E+04	1.00E+04	0	
asc_ctm_transfervariablebothnonauto	0	-1.00E+04	1.00E+04	0	
asc_drp_actdurless10min	0	-1.00E+04	1.00E+04	0	
asc_drp_dropoffvariable	0	-1.00E+04	1.00E+04	0	
asc_drp_someonedropped	0	-1.00E+04	1.00E+04	0	
asc_dth_actdurgreater10min	0	-1.00E+04	1.00E+04	1	
asc_dth_actdurless30min	0	-1.00E+04	1.00E+04	1	
asc_dth_tripdistgreater10mi	0	-1.00E+04	1.00E+04	0	
asc_emo_actdurgreater10min	0	-1.00E+04	1.00E+04	0	
asc_emo_actdurgreater150min	0	-1.00E+04	1.00E+04	0	
asc_emo_actdurless120min	0	-1.00E+04	1.00E+04	0	
asc_emo_adultparty12pmto2pm	0	-1.00E+04	1.00E+04	0	
asc_emo_adultpartyactdur20to40min	0	-1.00E+04	1.00E+04	0	
asc_emo_complexsubtour	0	-1.00E+04	1.00E+04	0	
asc_emo_complexsubtour12pmto2pm	0	-1.00E+04	1.00E+04	1	
asc_emo_groupeatoutduration	0	-1.00E+04	1.00E+04	0	
asc_emo_iswalkorwheelchair	0	-1.00E+04	1.00E+04	0	
asc_emo_simplesubtour	0	-1.00E+04	1.00E+04	0	
asc_emo_simplesubtour12pmto2pm	0	-1.00E+04	1.00E+04	1	
asc_emo_tripdistgreater10mi	0	-1.00E+04	1.00E+04	1	
asc_grc_actdurgreater10min	0	-1.00E+04	1.00E+04	0	
asc_grc_actdurgreater90min	0	-1.00E+04	1.00E+04	0	
asc_grc_adultparty12pmto2pm	0	-1.00E+04	1.00E+04	0	
asc_grc_groupgroceryduration	0	-1.00E+04	1.00E+04	0	
asc_grc_tripdistgreater10mi	0	-1.00E+04	1.00E+04	1	
asc_hcr_actdur30to90min	0	-1.00E+04	1.00E+04	0	
asc_her_actdurgreater10min	0	-1.00E+04	1.00E+04	1	
asc_her_actdurgreater45min	0	-1.00E+04	1.00E+04	0	
asc_her_actdurless30min	0	-1.00E+04	1.00E+04	1	
asc_her_tripdistgreater10mi	0	-1.00E+04	1.00E+04	1	
asc_lu_parks	0	-1.00E+04	1.00E+04	0	
asc_orc_actdurgreater10min	0	-1.00E+04	1.00E+04	1	
asc_orc_nearbigbox	0	-1.00E+04	1.00E+04	0	
asc_orc_nonmand	0	-1.00E+04	1.00E+04	0	
asc_pbs_actdurgreater120min	0	-1.00E+04	1.00E+04	1	
asc_pbs_actdurless30min	0	-1.00E+04	1.00E+04	1	
asc_pbs_complexsubtour	0	-1.00E+04	1.00E+04	0	
asc_pbs_simplesubtour	0	-1.00E+04	1.00E+04	0	
asc_pkp_actdurless10min	0	-1.00E+04	1.00E+04	0	
asc_pkp_pickupvariable	0	-1.00E+04	1.00E+04	0	
asc_pkp_someonepicked	0	-1.00E+04	1.00E+04	0	
asc_rec_grouprecreationduration	0	-1.00E+04	1.00E+04	0	
asc_rec_iswalkorwheelchair	0	-1.00E+04	1.00E+04	1	
asc_sch_schoolbusmode	0	-1.00E+04	1.00E+04	0	
asc_sch_schoollocationmatch	0	-1.00E+04	1.00E+04	0	
asc_shp_actdurless60min	0	-1.00E+04	1.00E+04	0	
asc_soc	0	-1.00E+04	1.00E+04	0	
asc_soc_bikemode	0	-1.00E+04	1.00E+04	1	
asc_soc_groupsocialvisitduration	0	-1.00E+04	1.00E+04	0	
asc_srv_actdurgreater30min	0	-1.00E+04	1.00E+04	0	
asc_srv_actdurless30min	0	-1.00E+04	1.00E+04	1	
asc_wrk_worklocationmatch	0	-1.00E+04	1.00E+04	0	
asc_wrl_complexsubtour	0	-1.00E+04	1.00E+04	0	
asc_wrl_ftworkeractdurless120min	0	-1.00E+04	1.00E+04	0	
asc_wrl_ptworkeractdurless120min	0	-1.00E+04	1.00E+04	0	
asc_wrl_simplesubtour	0	-1.00E+04	1.00E+04	1	
asc_wrl_univstudactdurless120min	0	-1.00E+04	1.00E+04	1	
child_dis_discretionary_starttime3pmto7pm	0	-1.00E+04	1.00E+04	0	
child_dis_eating_out_starttime11amto1pm	0	-1.00E+04	1.00E+04	1	
child_dis_eating_out_starttime5pmto7pm	0	-1.00E+04	1.00E+04	0	
child_dis_maintenance_starttime2pmto6pm	0	-1.00E+04	1.00E+04	0	
child_dis_shopping_starttime2pmto7pm	0	-1.00E+04	1.00E+04	1	
child_dis_visiting_starttime2pmto7pm	0	-1.00E+04	1.00E+04	0	
cra_all	0	-1.00E+04	1.00E+04	0	
cra_all	0	-1.00E+04	1.00E+04	0	
cra_notretr	0	-1.00E+04	1.00E+04	1	
ctm_child	0	-1.00E+04	1.00E+04	0	
ctm_drvchild	0	-1.00E+04	1.00E+04	0	
ctm_ftw	0	-1.00E+04	1.00E+04	0	
ctm_nonw	0	-1.00E+04	1.00E+04	0	
ctm_presc	0	-1.00E+04	1.00E+04	0	
ctm_ptw	0	-1.00E+04	1.00E+04	0	
ctm_retr	0	-1.00E+04	1.00E+04	0	
ctm_ustu	0	-1.00E+04	1.00E+04	0	
dis_discretionary_highincome	0	-1.00E+04	1.00E+04	0	
dis_discretionary_lu_commercial	0	-1.00E+04	1.00E+04	0	
dis_discretionary_zerocars	0	-1.00E+04	1.00E+04	0	
dis_eating_out_highincome	0	-1.00E+04	1.00E+04	0	
dis_eating_out_lu_commercial	0	-1.00E+04	1.00E+04	0	
dis_eating_out_zerocars	0	-1.00E+04	1.00E+04	0	
dis_escorting_female	0	-1.00E+04	1.00E+04	0	
dis_escorting_highschoolenrollment	0	-1.00E+04	1.00E+04	0	
dis_escorting_k8enrollment	0	-1.00E+04	1.00E+04	0	
dis_escorting_nondrivingchildren	0	-1.00E+04	1.00E+04	0	
dis_maintenance_female	0	-1.00E+04	1.00E+04	0	
dis_maintenance_lu_commercial	0	-1.00E+04	1.00E+04	0	
dis_maintenance_lu_institutional	0	-1.00E+04	1.00E+04	0	
dis_shopping_female	0	-1.00E+04	1.00E+04	0	
dis_shopping_lu_commercial	0	-1.00E+04	1.00E+04	0	
dis_visiting_highincome	0	-1.00E+04	1.00E+04	1	
drp_child	0	-1.00E+04	1.00E+04	0	
drp_drvchild	0	-1.00E+04	1.00E+04	0	
drp_ftw	0	-1.00E+04	1.00E+04	0	
drp_nonw	0	-1.00E+04	1.00E+04	0	
drp_presc	0	-1.00E+04	1.00E+04	0	
drp_ptw	0	-1.00E+04	1.00E+04	0	
drp_retr	0	-1.00E+04	1.00E+04	0	
drp_ustu	0	-1.00E+04	1.00E+04	0	
drvchild_dis_discretionary_starttime3pmto7pm	0	-1.00E+04	1.00E+04	0	
drvchild_dis_eating_out_starttime5pmto7pm	0	-1.00E+04	1.00E+04	0	
drvchild_dis_maintenance_starttime2pmto6pm	0	-1.00E+04	1.00E+04	1	
drvchild_dis_shopping_starttime3pmto5pm	0	-1.00E+04	1.00E+04	1	
drvchild_dis_visiting_starttime2pmto7pm	0	-1.00E+04	1.00E+04	1	
mnt_child	0	-1.00E+04	1.00E+04	0	
mnt_drvchild	0	-1.00E+04	1.00E+04	0	
mnt_ftw	0	-1.00E+04	1.00E+04	0	
mnt_nonw	0	-1.00E+04	1.00E+04	0	
mnt_presc	0	-1.00E+04	1.00E+04	0	
mnt_ptw	0	-1.00E+04	1.00E+04	0	
mnt_retr	0	-1.00E+04	1.00E+04	0	
mnt_ustu	0	-1.00E+04	1.00E+04	0	
emo_child	0	-1.00E+04	1.00E+04	0	
emo_drvchild	0	-1.00E+04	1.00E+04	0	
emo_ftw	0	-1.00E+04	1.00E+04	0	
emo_nonw	0	-1.00E+04	1.00E+04	0	
emo_presc	0	-1.00E+04	1.00E+04	0	
emo_ptw	0	-1.00E+04	1.00E+04	0	
emo_retr	0	-1.00E+04	1.00E+04	0	
emo_ustu	0	-1.00E+04	1.00E+04	0	
ftw_dis_discretionary_starttime5pmto7pm	0	-1.00E+04	1.00E+04	0	
ftw_dis_eating_out_starttime11amto1pm	0	-1.00E+04	1.00E+04	0	
ftw_dis_eating_out_starttime5pmto7pm	0	-1.00E+04	1.00E+04	0	
ftw_dis_maintenance_starttime3pmto6pm	0	-1.00E+04	1.00E+04	0	
ftw_dis_shopping_starttime3pmto7pm	0	-1.00E+04	1.00E+04	0	
ftw_dis_visiting_starttime3pmto8pm	0	-1.00E+04	1.00E+04	0	
nonw_dis_discretionary_startttime8amto11am	0	-1.00E+04	1.00E+04	0	
nonw_dis_eating_out_starttime11amto1pm	0	-1.00E+04	1.00E+04	0	
nonw_dis_eating_out_starttime5pmto7pm	0	-1.00E+04	1.00E+04	0	
nonw_dis_maintenance_startttime8amto2pm	0	-1.00E+04	1.00E+04	0	
nonw_dis_shopping_startttime9amto3pm	0	-1.00E+04	1.00E+04	0	
nonw_dis_visiting_starttime10amto1pm	0	-1.00E+04	1.00E+04	1	
presc_dis_eating_out_starttime11amto1pm	0	-1.00E+04	1.00E+04	0	
presc_dis_eating_out_starttime5pmto7pm	0	-1.00E+04	1.00E+04	0	
presc_dis_maintenance_starttime8amto2pm	0	-1.00E+04	1.00E+04	0	
presc_dis_shopping_starttime9amto11am	0	-1.00E+04	1.00E+04	1	
presc_dis_visiting_starttime2pmto7pm	0	-1.00E+04	1.00E+04	1	
ptw_dis_discretionary_starttime5pmto7pm	0	-1.00E+04	1.00E+04	0	
ptw_dis_eating_out_starttime11amto1pm	0	-1.00E+04	1.00E+04	0	
ptw_dis_eating_out_starttime5pmto7pm	0	-1.00E+04	1.00E+04	0	
ptw_dis_maintenance_startttime11amto6pm	0	-1.00E+04	1.00E+04	1	
ptw_dis_shopping_starttime11amto3pm	0	-1.00E+04	1.00E+04	0	
ptw_dis_visiting_starttime4pmto7pm	0	-1.00E+04	1.00E+04	0	
rec_child	0	-1.00E+04	1.00E+04	0	
rec_drvchild	0	-1.00E+04	1.00E+04	0	
rec_ftw	0	-1.00E+04	1.00E+04	0	
rec_nonw	0	-1.00E+04	1.00E+04	0	
rec_presc	0	-1.00E+04	1.00E+04	0	
rec_ptw	0	-1.00E+04	1.00E+04	0	
rec_retr	0	-1.00E+04	1.00E+04	0	
rec_ustu	0	-1.00E+04	1.00E+04	0	
retr_dis_discretionary_starttime8amto12pm	0	-1.00E+04	1.00E+04	0	
retr_dis_eating_out_starttime11amto1pm	0	-1.00E+04	1.00E+04	0	
retr_dis_eating_out_starttime5pmto7pm	0	-1.00E+04	1.00E+04	0	
retr_dis_maintenance_starttime8amto2pm	0	-1.00E+04	1.00E+04	0	
retr_dis_shopping_starttime9amto3pm	0	-1.00E+04	1.00E+04	0	
retr_dis_visiting_starttime2pmto5pm	0	-1.00E+04	1.00E+04	1	
sch_child	0	-1.00E+04	1.00E+04	1	
sch_drvchild	0	-1.00E+04	1.00E+04	1	
sch_ftw	0	-1.00E+04	1.00E+04	0	
sch_nonw	0	-1.00E+04	1.00E+04	0	
sch_presc	0	-1.00E+04	1.00E+04	1	
sch_ptw	0	-1.00E+04	1.00E+04	0	
sch_retr	0	-1.00E+04	1.00E+04	0	
sch_ustu	0	-1.00E+04	1.00E+04	0	
shp_child	0	-1.00E+04	1.00E+04	0	
shp_drvchild	0	-1.00E+04	1.00E+04	0	
shp_ftw	0	-1.00E+04	1.00E+04	0	
shp_nonw	0	-1.00E+04	1.00E+04	0	
shp_presc	0	-1.00E+04	1.00E+04	0	
shp_ptw	0	-1.00E+04	1.00E+04	0	
shp_retr	0	-1.00E+04	1.00E+04	0	
shp_ustu	0	-1.00E+04	1.00E+04	0	
soc_child	0	-1.00E+04	1.00E+04	1	
soc_drvchild	0	-1.00E+04	1.00E+04	1	
soc_ftw	0	-1.00E+04	1.00E+04	1	
soc_nonw	0	-1.00E+04	1.00E+04	1	
soc_presc	0	-1.00E+04	1.00E+04	1	
soc_ptw	0	-1.00E+04	1.00E+04	1	
soc_retr	0	-1.00E+04	1.00E+04	1	
soc_ustu	0	-1.00E+04	1.00E+04	1	
ustu_dis_eating_out_starttime11amto1pm	0	-1.00E+04	1.00E+04	1	
ustu_dis_eating_out_starttime5pmto7pm	0	-1.00E+04	1.00E+04	0	
wrk_child	0	-1.00E+04	1.00E+04	1	
wrk_drvchild	0	-1.00E+04	1.00E+04	1	
wrk_ftw	0	-1.00E+04	1.00E+04	0	
wrk_nonw	0	-1.00E+04	1.00E+04	1	
wrk_presc	0	-1.00E+04	1.00E+04	1	
wrk_ptw	0	-1.00E+04	1.00E+04	0	
wrk_retr	0	-1.00E+04	1.00E+04	1	
wrk_ustu	0	-1.00E+04	1.00E+04	1	
wrl_child	0	-1.00E+04	1.00E+04	1	
wrl_drvchild	0	-1.00E+04	1.00E+04	1	
wrl_ftw	0	-1.00E+04	1.00E+04	0	
wrl_nonw	0	-1.00E+04	1.00E+04	1	
wrl_presc	0	-1.00E+04	1.00E+04	1	
wrl_ptw	0	-1.00E+04	1.00E+04	0	
wrl_retr	0	-1.00E+04	1.00E+04	1	
wrl_ustu	0	-1.00E+04	1.00E+04	1	
					
					
					
					
					
					
[Utilities]					
//id	name	avail	linear-in-parameter expression (beta1*x1 + beta2*x2 + ... )		
4	change_travel_mode_transfer	isother	asc_ctm_iswalkorwheelchair * iswalkorwheelchair + asc_ctm_transfervariablebothnonauto * transfervariablebothnonauto + asc_ctm_transfervariableatleastonenonauto * transfervariableatleastonenonauto + ctm_ftw * finalftworker + ctm_ptw * finalptworker + ctm_ustu * finalunivstud + ctm_nonw * finalnonworker + ctm_retr * finalretiree + ctm_drvchild * finaldrivingagechild + ctm_child * finalpredriving + ctm_presc * finalpreschool		
5	dropped_off_passenger_from_car	one	dis_escorting_female * female + dis_escorting_nondrivingchildren * nondrivingchildren + dis_escorting_k8enrollment * k8enrollment + dis_escorting_highschoolenrollment * highschoolenrollment + asc_drp_dropoffvariable * dropoffvariable + asc_drp_someonedropped * someonedropped + asc_drp_actdurless10min * actdurless10min + drp_ftw * finalftworker + drp_ptw * finalptworker + drp_ustu * finalunivstud + drp_nonw * finalnonworker + drp_retr * finalretiree + drp_drvchild * finaldrivingagechild + drp_child * finalpredriving + drp_presc * finalpreschool		
6	picked_up_passenger_from_car	one	dis_escorting_female * female + dis_escorting_nondrivingchildren * nondrivingchildren + dis_escorting_k8enrollment * k8enrollment + dis_escorting_highschoolenrollment * highschoolenrollment + asc_pkp_pickupvariable * pickupvariable + asc_pkp_someonepicked * someonepicked + asc_pkp_actdurless10min * actdurless10min + drp_ftw * finalftworker + drp_ptw * finalptworker + drp_ustu * finalunivstud + drp_nonw * finalnonworker + drp_retr * finalretiree + drp_drvchild * finaldrivingagechild + drp_child * finalpredriving + drp_presc * finalpreschool		
8	work_doing_my_job	nothome	asc_wrk_worklocationmatch * worklocationmatch + wrk_ftw * finalftworker + wrk_ptw * finalptworker + wrk_ustu * finalunivstud + wrk_nonw * finalnonworker + wrk_retr * finalretiree + wrk_drvchild * finaldrivingagechild + wrk_child * finalpredriving + wrk_presc * finalpreschool		
11	school	nothome	asc_sch_schoolbusmode * schoolbusmode + asc_sch_schoollocationmatch * schoollocationmatch + sch_ftw * finalftworker + sch_ptw * finalptworker + sch_ustu * finalunivstud + sch_nonw * finalnonworker + sch_retr * finalretiree + sch_drvchild * finaldrivingagechild + sch_child * finalpredriving + sch_presc * finalpreschool		
13	work_related	nothome	asc_wrl_simplesubtour * simplesubtourstop + asc_wrl_complexsubtour * complexsubtourstop + asc_wrl_ftworkeractdurless120min * ftworkeractdurless120min + asc_wrl_ptworkeractdurless120min * ptworkeractdurless120min + asc_wrl_univstudactdurless120min * univstudactdurless120min + wrl_ftw * finalftworker + wrl_ptw * finalptworker + wrl_ustu * finalunivstud + wrl_nonw * finalnonworker + wrl_retr * finalretiree + wrl_drvchild * finaldrivingagechild + wrl_child * finalpredriving + wrl_presc * finalpreschool		
15	shopping	nothome	ftw_dis_shopping_starttime3pmto7pm * ftw_starttime3pmto7pm + ptw_dis_shopping_starttime11amto3pm * ptw_starttime11amto3pm + nonw_dis_shopping_startttime9amto3pm * nonw_startttime9amto3pm + retr_dis_shopping_starttime9amto3pm * retr_starttime9amto3pm + drvchild_dis_shopping_starttime3pmto5pm * drvchild_starttime3pmto5pm + child_dis_shopping_starttime2pmto7pm * child_starttime2pmto7pm + presc_dis_shopping_starttime9amto11am * presc_starttime9amto11am + dis_shopping_female * female + dis_shopping_lu_commercial * lu_commercial + asc_grc_adultparty12pmto2pm * adultparty12pmto2pm + asc_grc_actdurgreater10min * actdurgreater10min + asc_grc_tripdistgreater10mi * tripdistgreater10mi + asc_grc_actdurgreater90min * actdurgreater90min + asc_grc_groupgroceryduration * groupgroceryduration + asc_orc_nonmand * nonmand + asc_orc_nearbigbox * nearbigbox + asc_shp_actdurless60min * actdurless60min + shp_ftw * finalftworker + shp_ptw * finalptworker + shp_ustu * finalunivstud + shp_nonw * finalnonworker + shp_retr * finalretiree + shp_drvchild * finaldrivingagechild + shp_child * finalpredriving + shp_presc * finalpreschool		
7	maintenance	isother	ftw_dis_maintenance_starttime3pmto6pm * ftw_starttime3pmto6pm + ptw_dis_maintenance_startttime11amto6pm * ptw_startttime11amto6pm + nonw_dis_maintenance_startttime8amto2pm * nonw_startttime8amto2pm + retr_dis_maintenance_starttime8amto2pm * retr_starttime8amto2pm + drvchild_dis_maintenance_starttime2pmto6pm * drvchild_starttime2pmto6pm + child_dis_maintenance_starttime2pmto6pm * child_starttime2pmto6pm + presc_dis_maintenance_starttime8amto2pm * presc_starttime8amto2pm + dis_maintenance_female * female + dis_maintenance_lu_commercial * lu_commercial + dis_maintenance_lu_institutional * lu_institutional + asc_pbs_actdurgreater120min * actdurgreater120min + asc_pbs_actdurless30min * actdurless30min + asc_pbs_complexsubtour * complexsubtourstop + asc_pbs_simplesubtour * simplesubtourstop + asc_dth_actdurgreater10min * actdurgreater10min + asc_dth_tripdistgreater10mi * tripdistgreater10mi + asc_dth_actdurless30min * actdurless30min + asc_srv_actdurgreater30min * actdurgreater30min + asc_srv_actdurless30min * actdurless30min + asc_her_actdurgreater10min * actdurgreater10min + asc_her_tripdistgreater10mi * tripdistgreater10mi + asc_her_actdurgreater45min * actdurgreater45min + asc_her_actdurless30min * actdurless30min + asc_hcr_actdur30to90min * actdur30to90min + mnt_ftw * finalftworker + mnt_ptw * finalptworker + mnt_ustu * finalunivstud + mnt_nonw * finalnonworker + mnt_retr * finalretiree + mnt_drvchild * finaldrivingagechild + mnt_child * finalpredriving + mnt_presc * finalpreschool		
21	eat_meal_out_at_restaurant_diner	nothome	ftw_dis_eating_out_starttime11amto1pm * ftw_starttime11amto1pm + ftw_dis_eating_out_starttime5pmto7pm * ftw_starttime5pmto7pm + ptw_dis_eating_out_starttime11amto1pm * ptw_starttime11amto1pm + ptw_dis_eating_out_starttime5pmto7pm * ptw_starttime5pmto7pm + ustu_dis_eating_out_starttime11amto1pm * ustu_starttime11amto1pm + ustu_dis_eating_out_starttime5pmto7pm * ustu_starttime5pmto7pm + nonw_dis_eating_out_starttime11amto1pm * nonw_starttime11amto1pm + nonw_dis_eating_out_starttime5pmto7pm * nonw_starttime5pmto7pm + retr_dis_eating_out_starttime11amto1pm * retr_starttime11amto1pm + retr_dis_eating_out_starttime5pmto7pm * retr_starttime5pmto7pm + drvchild_dis_eating_out_starttime5pmto7pm * drvchild_starttime5pmto7pm + child_dis_eating_out_starttime11amto1pm * child_starttime11amto1pm + child_dis_eating_out_starttime5pmto7pm * child_starttime5pmto7pm + presc_dis_eating_out_starttime11amto1pm * presc_starttime11amto1pm + presc_dis_eating_out_starttime5pmto7pm * presc_starttime5pmto7pm + dis_eating_out_zerocars * zerocars + dis_eating_out_highincome * highincome + dis_eating_out_lu_commercial * lu_commercial + asc_emo_iswalkorwheelchair * iswalkorwheelchair + asc_emo_adultparty12pmto2pm * adultparty12pmto2pm + asc_emo_adultpartyactdur20to40min * adultpartyactdur20to40min + asc_emo_simplesubtour12pmto2pm * simplesubtour12pmto2pm + asc_emo_complexsubtour12pmto2pm * complexsubtour12pmto2pm + asc_emo_simplesubtour * simplesubtourstop + asc_emo_complexsubtour * complexsubtourstop + asc_emo_actdurgreater10min * actdurgreater10min + asc_emo_tripdistgreater10mi * tripdistgreater10mi + asc_emo_groupeatoutduration * groupeatoutduration + asc_emo_actdurgreater150min * actdurgreater150min + asc_emo_actdurless120min * actdurless120min + emo_ftw * finalftworker + emo_ptw * finalptworker + emo_ustu * finalunivstud + emo_nonw * finalnonworker + emo_retr * finalretiree + emo_drvchild * finaldrivingagechild + emo_child * finalpredriving + emo_presc * finalpreschool		
22	civic_or_religious_activities	nothome	cra_all * one + cra_notretr * notretiredadult + dis_discretionary_zerocars * zerocars + dis_discretionary_highincome * highincome + dis_discretionary_lu_commercial * lu_commercial + asc_cra_nearchurch * nearchurch + asc_cra_lu_institutional * lu_institutional		
23	entertainement	nothome	ftw_dis_discretionary_starttime5pmto7pm * ftw_starttime5pmto7pm + ptw_dis_discretionary_starttime5pmto7pm * ptw_starttime5pmto7pm + nonw_dis_discretionary_startttime8amto11am * nonw_startttime8amto11am + retr_dis_discretionary_starttime8amto12pm * retr_starttime8amto12pm + drvchild_dis_discretionary_starttime3pmto7pm * drvchild_starttime3pmto7pm + child_dis_discretionary_starttime3pmto7pm * child_starttime3pmto7pm + dis_discretionary_zerocars * zerocars + dis_discretionary_highincome * highincome + dis_discretionary_lu_commercial * lu_commercial + asc_lu_parks * lu_parks + asc_rec_iswalkorwheelchair * iswalkorwheelchair + asc_rec_grouprecreationduration * grouprecreationduration + rec_ftw * finalftworker + rec_ptw * finalptworker + rec_ustu * finalunivstud + rec_nonw * finalnonworker + rec_retr * finalretiree + rec_drvchild * finaldrivingagechild + rec_child * finalpredriving + rec_presc * finalpreschool		
25	social_visit_friends_relatives	nothome	asc_soc * one + ftw_dis_visiting_starttime3pmto8pm * ftw_starttime3pmto8pm + ptw_dis_visiting_starttime4pmto7pm * ptw_starttime4pmto7pm + nonw_dis_visiting_starttime10amto1pm * nonw_starttime10amto1pm + retr_dis_visiting_starttime2pmto5pm * retr_starttime2pmto5pm + drvchild_dis_visiting_starttime2pmto7pm * drvchild_starttime2pmto7pm + child_dis_visiting_starttime2pmto7pm * child_starttime2pmto7pm + presc_dis_visiting_starttime2pmto7pm * presc_starttime2pmto7pm + dis_visiting_highincome * highincome + asc_soc_bikemode * bikemode + asc_soc_groupsocialvisitduration * groupsocialvisitduration + soc_ftw * finalftworker + soc_ptw * finalptworker + soc_ustu * finalunivstud + soc_nonw * finalnonworker + soc_retr * finalretiree + soc_drvchild * finaldrivingagechild + soc_child * finalpredriving + soc_presc * finalpreschool		
					
[Expressions] 					
// Define here arithmetic expressions for name that are not directly 					
// available from the data					
one = 1					
short_stop = actdurless60min == 1					
ishome = ptype == 1					
iswork = ptype == 2					
ischool = ptype == 3					
isother = ptype > 3					
nothome =  ptype != 1					
ishomeandworkadult = ptype == 1 && (finalftworker == 1 || finalptworker == 1 || finalunivstud == 1)					
ishomeandadult = ptype == 1 && (finalftworker == 1 || finalptworker == 1 || finalunivstud == 1 || finalretiree == 1)					
notretiredadult = finalftworker == 1 || finalptworker || 0					
ftw_starttime11amto1pm = finalftworker == 1 && starttime11amto1pm == 1					
ftw_starttime3pmto6pm = finalftworker == 1 && starttime3pmto6pm == 1					
ftw_starttime3pmto7pm = finalftworker == 1 && starttime3pmto7pm == 1					
ftw_starttime3pmto8pm = finalftworker == 1 && starttime3pmto8pm == 1					
ftw_starttime5pmto7pm = finalftworker == 1 && starttime5pmto7pm == 1					
ptw_starttime11amto1pm = finalptworker == 1 && starttime11amto1pm == 1					
ptw_starttime11amto3pm = finalptworker == 1 && starttime11amto3pm == 1					
ptw_startttime11amto6pm = finalptworker == 1 && (arrhour >10 && arrhour < 19)					
ptw_starttime4pmto7pm = finalptworker == 1 && starttime4pmto7pm == 1					
ptw_starttime3pmto8pm = finalptworker == 1 && starttime3pmto8pm == 1					
ptw_starttime5pmto7pm = finalptworker == 1 && starttime5pmto7pm == 1					
ustu_starttime11amto1pm = finalunivstud == 1 && starttime11amto1pm == 1					
ustu_starttime5pmto7pm = finalunivstud == 1 && starttime5pmto7pm == 1					
nonw_startttime8amto11am = finalnonworker == 1 && starttime8amto11am == 1					
nonw_startttime8amto2pm = finalnonworker == 1 && starttime8amto2pm == 1					
nonw_startttime9amto3pm = finalnonworker == 1 && starttime9amto3pm == 1					
nonw_starttime10amto1pm = finalnonworker == 1 && starttime10amto1pm == 1					
nonw_starttime11amto1pm = finalnonworker == 1 && starttime11amto1pm == 1					
nonw_starttime5pmto7pm = finalnonworker == 1 && starttime5pmto7pm == 1					
retr_starttime8amto12pm = finalretiree == 1 && starttime8amto12pm == 1					
retr_starttime8amto2pm = finalretiree == 1 && starttime8amto2pm == 1					
retr_starttime9amto3pm = finalretiree == 1 && starttime9amto3pm == 1					
retr_starttime11amto1pm = finalretiree == 1 && starttime11amto1pm == 1					
retr_starttime2pmto5pm = finalretiree == 1 && starttime2pmto5pm == 1					
retr_starttime5pmto7pm = finalretiree == 1 && starttime5pmto7pm == 1					
drvchild_starttime11amto1pm = finaldrivingagechild == 1 && starttime11amto1pm == 1					
drvchild_starttime2pmto6pm = finaldrivingagechild == 1 && starttime2pmto6pm == 1					
drvchild_starttime2pmto7pm = finaldrivingagechild == 1 && starttime2pmto7pm == 1					
drvchild_starttime3pmto5pm = finaldrivingagechild == 1 && starttime3pmto5pm == 1					
drvchild_starttime3pmto7pm = finaldrivingagechild == 1 && starttime3pmto7pm == 1					
drvchild_starttime5pmto7pm = finaldrivingagechild == 1 && starttime5pmto7pm == 1					
child_starttime11amto1pm = finalpredriving == 1 && starttime11amto1pm == 1					
child_starttime2pmto6pm = finalpredriving == 1 && starttime2pmto6pm == 1					
child_starttime2pmto7pm = finalpredriving == 1 && starttime2pmto7pm == 1					
child_starttime3pmto7pm = finalpredriving == 1 && starttime3pmto7pm == 1					
child_starttime5pmto7pm = finalpredriving == 1 && starttime5pmto7pm == 1					
presc_starttime8amto12pm = finalpreschool == 1 && starttime8amto12pm == 1					
presc_starttime8amto2pm = finalpreschool == 1 && starttime8amto2pm == 1					
presc_starttime9amto11am = finalpreschool == 1 && starttime9amto11am == 1					
presc_starttime11amto1pm = finalpreschool == 1 && starttime11amto1pm == 1					
presc_starttime2pmto7pm = finalpreschool == 1 && starttime2pmto7pm == 1					
presc_starttime5pmto7pm = finalpreschool == 1 && starttime5pmto7pm == 1					
simplesubtourstop = simplesubtour > 0 && ptype != 2 && ptype != 4					
complexsubtourstop = complexsubtour > 0 && ptype != 2 && ptype != 4					
					
					
[Exclude]					
// All observations verifying the following expression will not be					
// considered for estimation					
apurp < 4 || apurp > 25					
					
[Model]					
$NGEV					
					
[NetworkGEVNodes]					
// name	default	lb	up	status	
agg_mode_change	1	1	10	1	
agg_non_work	1	1	10	0	
agg_university_or_school	1	1	10	1	
agg_work	1	1	10	1	
dis_mode_change	1	1	10	1	
dis_discretionary	1	1	10	1	
dis_eating_out	1	1	10	1	
dis_escorting	1	1	10	0	
dis_maintenance	1	1	10	1	
dis_shopping	1	1	10	1	
dis_visiting	1	1	10	1	
dis_university_or_school	1	1	10	1	
dis_work	1	1	10	0	
					
[NetworkGEVLinks]					
// a_node	b_node	default	lb	up	status
_ROOT	agg_mode_change	1	-1.00E+02	1.00E+05	1
_ROOT	agg_non_work	1	-1.00E+02	1.00E+05	1
_ROOT	agg_university_or_school	1	-1.00E+02	1.00E+05	1
_ROOT	agg_work	1	-1.00E+02	1.00E+05	1
agg_mode_change	dis_mode_change	1	-1.00E+02	1.00E+05	1
agg_non_work	dis_discretionary	1	-1.00E+02	1.00E+05	1
agg_non_work	dis_eating_out	1	-1.00E+02	1.00E+05	1
agg_non_work	dis_escorting	1	-1.00E+02	1.00E+05	1
agg_non_work	dis_maintenance	1	-1.00E+02	1.00E+05	1
agg_non_work	dis_shopping	1	-1.00E+02	1.00E+05	1
agg_non_work	dis_visiting	1	-1.00E+02	1.00E+05	1
agg_university_or_school	dis_university_or_school	1	-1.00E+02	1.00E+05	1
agg_work	dis_work	1	-1.00E+02	1.00E+05	1
dis_discretionary	civic_or_religious_activities	1	-1.00E+02	1.00E+05	1
dis_discretionary	entertainement	1	-1.00E+02	1.00E+05	1
dis_eating_out	eat_meal_out_at_restaurant_diner	1	-1.00E+02	1.00E+05	1
dis_escorting	dropped_off_passenger_from_car	1	-1.00E+02	1.00E+05	1
dis_escorting	picked_up_passenger_from_car	1	-1.00E+02	1.00E+05	1
dis_maintenance	maintenance	1	-1.00E+02	1.00E+05	1
dis_mode_change	change_travel_mode_transfer	1	-1.00E+02	1.00E+05	1
dis_shopping	shopping	1	-1.00E+02	1.00E+05	1
dis_university_or_school	school	1	-1.00E+02	1.00E+05	1
dis_visiting	social_visit_friends_relatives	1	-1.00E+02	1.00E+05	1
dis_work	work_doing_my_job	1	-1.00E+02	1.00E+05	1
dis_work	work_related	1	-1.00E+02	1.00E+05	1
