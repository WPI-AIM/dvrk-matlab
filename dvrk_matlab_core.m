%Developed By: Adnan Munawar (amunawar@wpi.edu)
%AIM Labs
%Worcester Poltechnic Institute (WPI)
clear all
close all
clear global
clc;

fig = dvrk_matlab_gui;
fig_handles = guidata(fig);
global node psm1_sub;
assign_callbacks(fig_handles);