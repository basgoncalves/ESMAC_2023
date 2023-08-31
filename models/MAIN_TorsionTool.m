%-------------------------------------------------------------------------%
% Copyright (c) 2021 % Kirsten Veerkamp, Hans Kainz, Bryce A. Killen,     %
%    Hulda Jónasdóttir, Marjolein M. van der Krogt     		              %
%                                                                         %
% Licensed under the Apache License, Version 2.0 (the "License");         %
% you may not use this file except in compliance with the License.        %
% You may obtain a copy of the License at                                 %
% http://www.apache.org/licenses/LICENSE-2.0.                             %
%                                                                         % 
% Unless required by applicable law or agreed to in writing, software     %
% distributed under the License is distributed on an "AS IS" BASIS,       %
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or         %
% implied. See the License for the specific language governing            %
% permissions and limitations under the License.                          %
%                                                                         %
%    Authors: Hulda Jónasdóttir & Kirsten Veerkamp                        %
%                            February 2021                                %
%    email:    k.veerkamp@amsterdamumc.nl                                 % 
% ----------------------------------------------------------------------- %
%%%  main script to create opensim model with personalised geometries   %%%
% Give the subject-specific femoral anteversion (AV) and neck-shaft (NS) angles,
% 	as well as the tibial torsion (TT) angles, as input for the right and left leg.
% 	Lines which require these inputs are indicated by a % at the end of the line.
% The final model with personalised torsions is saved in the DEFORMED_MODEL
% 	folder, and is called FINAL_PERSONALISEDTORSIONS.osim.
% 	The adjusted markerset can also be found in this folder.
% 
% note1: The angle definitions for AV and TT are as follows:
% 	- AV: positive: femoral anteversion; negative: femoral retroversion.
% 	- TT: positive: external rotation; negative: internal rotation.
% note2: Adjust the MarkerSet.xml in the main folder to your marker set,
% 	when using markers for the greater trochanter (when adjusting
% 	femur) and/or when using markers on the feet (when adjusting tibia).
% note3: If you only wish to adjust the femoral geometry (and not the tibial
% 	torsion), set the input to the tibial torsion to 0 degrees (=default
% 	tibial torsion in generic femur).
%
% 
% 12/26/2022
% changes Elias Wallnoefer:
% Femur torsion should now work with RajagopalModel
% FinalModel = "leftNSA*"
%
% ! Tibia torsion does not yet work - hard coded line-numbers of XML need to
% be fixed in tibia.m and tibia_locationInParent-rotation retested +
% adapted for both models
%

% ----------------------------------------------------------------------- %
function MAIN_TorsionTool()

% add folder to path
activeFile = [mfilename('fullpath') '.m'];    
mfile_name = mfilename('fullpath');
[pathstr,name,ext] = fileparts(mfile_name);
cd(pathstr);
try
    delete('DEFORMED_MODEL/*');
end
addpath(genpath(pwd))
deformed_model_path = [pathstr '\DEFORMED_MODEL'];

% you have to measure this on the OpenSim Geometry with the same method as with your participants!
default_Anteversion = 17.6; 
default_NeckShaftAngle = 123.3;
default_TibiaTorsion = 0;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%                                                                                                                 %
%  -------------------------------------------- ONLY EDIT THIS -------------------------------------------------- %
%                                                                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% model to use
OG_model = 'Rajagopal\Rajagopal2015_os4_UniVie.osim';
GeometryFolder = 'Rajagopal/Geometry';
OG_markerset = 'markerset_UniVie_os4.xml';
applyTibiaTorsionToJointOffset = 1; 
% applyTibiaTorsionToJointOffset = 0 is the original method where torsion is applied 
% via translation and rotation axis and not via body coordinate
% system rotation. This method is not applicable with Rajagopal model
% because it does not have these elements...

% subjects to run
Subjects = {'P03'};
TorsionAngles = {};
TorsionAngles{end+1} = [126.3, 17.8, 39.3, 129.1, 6.94, 44.4]; % p003

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 

for i = 1:length(Subjects)
    angle_NS_right = TorsionAngles{i}(1); % right neck-shaft angle (in degrees) %
    angle_AV_right = TorsionAngles{i}(2); % right anteversion angle (in degrees) %
    angle_TT_right = TorsionAngles{i}(3); % right tibial torsion angle (in degrees) %

    angle_NS_left = TorsionAngles{i}(4); % left neck-shaft angle (in degrees) %
    angle_AV_left = TorsionAngles{i}(5); % left anteversion angle (in degrees) %
    angle_TT_left = TorsionAngles{i}(6); % left tibial torsion angle (in degrees) %
    
    addpath(genpath(deformed_model_path))
    %% right femur
    deform_bone = 'F';
    which_leg = 'R';
    deformed_model = ['rightNSA' num2str(angle_NS_right) '_rightAVA' num2str(angle_AV_right) ];
    make_PEmodel(OG_model, deformed_model, OG_markerset, deform_bone, which_leg, angle_AV_right - default_Anteversion, angle_NS_right - default_NeckShaftAngle, GeometryFolder);

    %% left femur
    model = [deformed_model '.osim'];
    markerset = [deformed_model '_' OG_markerset];
    deform_bone = 'F';
    which_leg = 'L';
    deformed_model = [ 'leftNSA' num2str(angle_NS_left) '_leftAVA' num2str(angle_AV_left)];
    make_PEmodel( model, deformed_model, markerset, deform_bone, which_leg, angle_AV_left - default_Anteversion, angle_NS_left - default_NeckShaftAngle, GeometryFolder);

    %% right tibia
    model = [deformed_model '.osim'];
    markerset = [deformed_model '_' markerset];
    deformed_model = 'RT15';
    deform_bone = 'T';
    which_leg = 'R';
    deformed_model = [ 'rightTT' num2str(angle_TT_right) ];
    make_PEmodel( model, deformed_model, markerset, deform_bone, which_leg, angle_TT_right -default_TibiaTorsion, [], GeometryFolder, applyTibiaTorsionToJointOffset);

    %% left tibia
    model = [deformed_model '.osim'];
    markerset = [deformed_model '_' markerset];
    deformed_model = 'LT5';
    deform_bone = 'T';
    which_leg = 'L';
    deformed_model = [ 'leftTT' num2str(angle_TT_left) ];
    make_PEmodel( model, deformed_model, markerset, deform_bone, which_leg, angle_TT_left -default_TibiaTorsion, [], GeometryFolder, applyTibiaTorsionToJointOffset);

    %% save as the patient model

    rmpath(genpath(deformed_model_path))
    subject_model_folder = [pathstr '\' Subjects{i}];
    copyfile(deformed_model_path,subject_model_folder)
    delete_files_in_deformed_path(deformed_model_path)
    close all
end


function delete_files_in_deformed_path(deformed_model_path)

files_in_deformed_path = dir(deformed_model_path);
for iFile = 3:length(files_in_deformed_path)
    file_dir = [files_in_deformed_path(iFile).folder fp files_in_deformed_path(iFile).name];
    if ~contains(file_dir,'Geometry')
        delete(file_dir)
    end
end






