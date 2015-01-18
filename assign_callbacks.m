%Developed By: Adnan Munawar (amunawar@wpi.edu)
%AIM Labs
%Worcester Poltechnic Institute (WPI)
function assign_callbacks(gui_handle)
%Assign callback to each gui element in this function
set(gui_handle.radiobutton_connect_to_ros,'Callback',{@radio_connect_to_ros_cb});
set(gui_handle.radiobutton_connect_to_psm1,'Callback',{@radio_connect_to_psm1_cb,gui_handle});
set(gui_handle.radiobutton_connect_to_mtmr,'Callback',{@radio_connect_to_mtmr_cb,gui_handle});
end

%CallBack for Enabling connection to ROS

function radio_connect_to_ros_cb(hObject,evenData)
global node;
if (get(hObject,'Value') == get(hObject,'Max'))
	display('Connecting to ROS server, make sure ROS is running before hand');
    node = rosmatlab.node('/dvrk_matlab_core');
    set(hObject,'String','Connected!');
else
	display('Deleting Node');
    node.delete;
    set(hObject,'String','Disconnected!');
end
end

%Callback for setting PSM1 publisher and subscribe
function radio_connect_to_psm1_cb(hObject,eventData,gui_handles)
global node psm1_sub psm1_pub psm1_pub_msg psm1_pub_ready;
if (get(hObject,'Value') == get(hObject,'Max'))
	display('Subscribing to PSM1 topic');
    psm1_sub = node.addSubscriber('/dvrk_psm/joint_position_current','sensor_msgs/JointState',10);
    psm1_sub.addCustomMessageListener({@psm1_subscriber_cb,gui_handles});
    %Create snsr_msg/JS type message
    psm1_pub_msg = rosmatlab.message('sensor_msgs/JointState',node);
    display('Creating PSM1 Publisher');
    psm1_pub = node.addPublisher('/dvrk_psm/set_position_joint','sensor_msgs/JointState');
    %Set the callback of PSM sliders to one function
    psm1_pub_ready = true;
else
	disp('Deleting PSM1 Subscriber Topic');
    node.removeSubscriber(psm1_sub);
    disp('Deleting PSM1 Publisher');
    node.removePublisher(psm1_pub);
    psm1_pub_ready = false;
end
end

%Callback for setting PSM1 publisher and subscribe
function radio_connect_to_mtmr_cb(hObject,eventData,gui_handles)
global node mtmr_sub mtmr_pub mtmr_pub_msg mtmr_pub_ready;
if (get(hObject,'Value') == get(hObject,'Max'))
	display('Subscribing to MTMR topic');
    mtmr_sub = node.addSubscriber('/dvrk_mtm/joint_position_current','sensor_msgs/JointState',10);
    mtmr_sub.addCustomMessageListener({@mtmr_subscriber_cb,gui_handles});
    %Create snsr_msg/JS type message
    mtmr_pub_msg = rosmatlab.message('sensor_msgs/JointState',node);
    display('Creating MTMR Publisher');
    mtmr_pub = node.addPublisher('/dvrk_mtm/set_position_joint','sensor_msgs/JointState');
    %Set the callback of PSM sliders to one function
    mtmr_pub_ready = true;
else
	disp('Deleting MTMR Subscriber Topic');
    node.removeSubscriber(mtmr_sub);
    disp('Deleting PSM1 Publisher');
    node.removePublisher(mtmr_pub);
    mtmr_pub_ready = false;
end
end

% PSM Subscriber Callback for "/dvrk_psm/joint_position_current"
function psm1_subscriber_cb(handle,event,gui_handles)
message = event.JavaEvent.getSource;
currPosition = message.getPosition;
if (size(currPosition,1) ~= 7)
    disp('PSM: Error! Number of Joints is not equal to 7');
else
set(gui_handles.edit1_psm1,'String',num2str(currPosition(1)));
set(gui_handles.edit2_psm1,'String',num2str(currPosition(2)));
set(gui_handles.edit3_psm1,'String',num2str(currPosition(3)));
set(gui_handles.edit4_psm1,'String',num2str(currPosition(4)));
set(gui_handles.edit5_psm1,'String',num2str(currPosition(5)));
set(gui_handles.edit6_psm1,'String',num2str(currPosition(6)));
set(gui_handles.edit7_psm1,'String',num2str(currPosition(7)));
end
end

% MTM Subscriber Callback for "/dvrk_mtm/joint_position_current"
function mtmr_subscriber_cb(handle,event,gui_handles)
message = event.JavaEvent.getSource;
currPosition = message.getPosition;
if (size(currPosition,1) ~= 7)
    disp('MTMR: Error! Number of Joints is not equal to 7');
else
set(gui_handles.edit1_mtmr,'String',num2str(currPosition(1)));
set(gui_handles.edit2_mtmr,'String',num2str(currPosition(2)));
set(gui_handles.edit3_mtmr,'String',num2str(currPosition(3)));
set(gui_handles.edit4_mtmr,'String',num2str(currPosition(4)));
set(gui_handles.edit5_mtmr,'String',num2str(currPosition(5)));
set(gui_handles.edit6_mtmr,'String',num2str(currPosition(6)));
set(gui_handles.edit7_mtmr,'String',num2str(currPosition(7)));
end
end


