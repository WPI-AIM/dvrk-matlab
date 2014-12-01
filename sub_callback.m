%Custom Callback Function
function sub_callback(handles, event, gui_handles)

global first_launch;

%Get Message from Java Event
message = event.JavaEvent.getSource;
if (first_launch == 1)
    set_gui_joint_names(gui_handles,message);
    first_launch = 0;
end

%Store position in new variable to extract individual joint values
currPosition = message.getPosition;

if (size(currPosition,1) ~= 7)
    disp('Error! Number of Joints is not equal to 7');
else
%Display the Joint Values in the Matlab GUI
set(gui_handles.edit1,'String',num2str(currPosition(1)));
set(gui_handles.edit2,'String',num2str(currPosition(2)));
set(gui_handles.edit3,'String',num2str(currPosition(3)));
set(gui_handles.edit4,'String',num2str(currPosition(4)));
set(gui_handles.edit5,'String',num2str(currPosition(5)));
set(gui_handles.edit6,'String',num2str(currPosition(6)));
set(gui_handles.edit7,'String',num2str(currPosition(7)));
end
end