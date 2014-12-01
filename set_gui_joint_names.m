function set_gui_joint_names(gui_handles,message)
% Read the Joint Names from ROS server and set them to Matlab GUI
% only the first time the Matlab Program Runs

if (message.getName.size ~= 7)
    disp('Error! Number of Joints is not equal to 7')
else
disp('Setting Joint Names for the first time');
set(gui_handles.text1,'String',message.getName.get(0));
set(gui_handles.text2,'String',message.getName.get(1));
set(gui_handles.text3,'String',message.getName.get(2));
set(gui_handles.text4,'String',message.getName.get(3));
set(gui_handles.text5,'String',message.getName.get(4));
set(gui_handles.text6,'String',message.getName.get(5));
set(gui_handles.text7,'String',message.getName.get(6));
end
end