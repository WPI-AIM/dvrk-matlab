%Developed By: Adnan Munawar (amunawar@wpi.edu)
%AIM Labs
%Worcester Poltechnic Institute (WPI)
clear all
close all
clear global
clc;

fig = dvrk_matlab_gui;
fig_handles = guidata(fig);
global node psm1_sub psm1_pub psm1_pub_msg psm1_pub_ready;
psm1_pub_ready = false;
assign_callbacks(fig_handles);

while(1)
    if(psm1_pub_ready == true)
    psm1_pub_joint_pos(fig_handles);
    end
    pause(0.001);
end