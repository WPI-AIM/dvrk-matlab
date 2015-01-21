%Developed By: Adnan Munawar (amunawar@wpi.edu)
%AIM Labs
%Worcester Poltechnic Institute (WPI)
clear all
close all
clear global
clc;

fig = dvrk_matlab_gui;
fig_handles = guidata(fig);
%Function to Init Gui and set all radio buttons to zero.
init_gui(fig_handles);
global MTMR PSM1;
MTMR.pub_ready = false;
PSM1.pub_ready = false;
assign_callbacks(fig_handles);

while(1)
    if(PSM1.pub_ready == true)
    psm1_pub_joint_pos(fig_handles);
    end
    if(MTMR.pub_ready == true)
    mtmr_pub_joint_pos(fig_handles);
    end
    pause(0.001);
end