%Developed By: Adnan Munawar (amunawar@wpi.edu)
%AIM Labs
%Worcester Poltechnic Institute (WPI)
clear all
close all
clear global
clc;
%Create Global Structure for each ARM
global MTMR PSM1;

fig = dvrk_matlab_gui;
fig_handles = guidata(fig);
%Function to Init Gui and set all radio buttons to zero.
init_gui(fig_handles);
assign_callbacks(fig_handles);

while(1)
    % Only publish jnt_pos when manipulators are ready (Homed).
    % manip_state is continuously updated from listening to current
    % manipulator state
    if(strcmp(PSM1.manip_state,'PSM_READY'))
    psm1_pub_joint_pos(fig_handles);
    end
    if(strcmp(MTMR.manip_state,'MTM_READY'))
    mtmr_pub_joint_pos(fig_handles);
    end
    pause(0.001);
end