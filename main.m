% run some code 

trialPath1 = 'C:\Git\ESMAC_2023\simulations\P03\pre_GUI\Dynamic03_l';
trialPath2 = 'C:\Git\ESMAC_2023\simulations\P03\pre_GUI\BKresults_manual_pasted';
saveDir    = 'C:\Git\ESMAC_2023\simulations\P03\pre_GUI';
modelName  = 'Rajagopal';
side       = 'l';
compare2trialOsim(trialPath1,trialPath2,saveDir,modelName,side)

%
trialPath1 = 'C:\Git\ESMAC_2023\simulations\P03\pre_GUI\Dynamic03_l';
trialPath2 = 'C:\Git\ESMAC_2023\simulations\P03\pre_GUI\BKresults_manual_pasted';
saveDir    = 'C:\Git\ESMAC_2023\simulations\P03\pre_GUI\BG_vs_BAK_re_ran';
modelName  = 'Rajagopal';
side       = 'l';
compare2trialOsim(trialPath1,trialPath2,saveDir,modelName,side)


% re-ran BAK simulations with JRA using the SO_force instead of the
% controls
trialPath1 = 'C:\Git\ESMAC_2023\simulations\P03\pre_GUI\Dynamic03_l';
trialPath2 = 'C:\Git\ESMAC_2023\simulations\P03\pre_GUI\\Dynamic03_l_BAK_settings_JRA_no_controls';
saveDir    = 'C:\Git\ESMAC_2023\simulations\P03\pre_GUI\BG_vs_BAK_SO_force';
modelName  = 'Rajagopal';
side       = 'l';
compare2trialOsim(trialPath1,trialPath2,saveDir,modelName,side)



marker_virtual_path = 'C:\Git\research_data\Projects\torsion_deformities_healthy_kinematics\simulations\TD03\pre_generic\dynamic_1_l_b\_ik_model_marker_locations.sto';
marker_experimental_path = 'C:\Git\research_data\Projects\torsion_deformities_healthy_kinematics\simulations\TD03\pre_generic\dynamic_1_l_b\marker_experimental.trc';

