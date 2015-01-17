%Developed By: Adnan Munawar (amunawar@wpi.edu)
%AIM Labs
%Worcester Poltechnic Institute (WPI)
clear all
close all
clear global
clc;

fig = dvrk_matlab_gui;
fig_handles = guidata(fig);
global mtmr_pub_ready psm1_pub_ready;
mtmr_pub_ready = false;
psm1_pub_ready = false;
assign_callbacks(fig_handles);

while(1)
    if(psm1_pub_ready == true)
    psm1_pub_joint_pos(fig_handles);
    end
    if(mtmr_pub_ready == true)
    mtmr_pub_joint_pos(fig_handles);
    end
    pause(0.001);
end