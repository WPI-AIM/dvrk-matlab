%Developed By: Adnan Munawar (amunawar@wpi.edu)
%AIM Labs
%Worcester Poltechnic Institute (WPI)
function assign_callbacks(gui_handle)
%Assign callback to each gui element in this function
set(gui_handle.radiobutton_connect_to_ros,'Callback',{@radio_connect_to_ros_cb});
set(gui_handle.radiobutton_connect_to_psm1,'Callback',{@radio_connect_to_psm1_cb,gui_handle});
set(gui_handle.radiobutton_connect_to_mtmr,'Callback',{@radio_connect_to_mtmr_cb,gui_handle});
set(gui_handle.pushbutton_home,'Callback',{@pushbutton_home});
end

%CallBack for Enabling connection to ROS

function radio_connect_to_ros_cb(hObject,eventData)
global node PSM1 MTMR;
if (get(hObject,'Value') == get(hObject,'Max'))
	display('Connecting to ROS server, make sure ROS is running before hand');
    node = rosmatlab.node('/dvrk_matlab_core');
    set(hObject,'String','Connected!');
    PSM1.active = false;
    MTMR.active = false;
else
	display('Deleting Node');
    node.delete;
    set(hObject,'String','Disconnected!');
end
end

function pushbutton_home(hObject, eventData)
global PSM1 MTMR
if (get(hObject,'Value') == get(hObject,'Max'))
% Set state_msg = "Home" and publish to specified topic
if (PSM1.active == true)
PSM1.state_msg.setData('Home');
PSM1.state_pub.publish(PSM1.state_msg);
display('Sending Home Command to PSM1');
PSM1.jnt_pub_ready = true;
end
% Set state_msg = "Home" and publish to specified topic
if (MTMR.active == true)
MTMR.state_msg.setData('Home');
MTMR.state_pub.publish(MTMR.state_msg);
display('Sending Home Command to MTMR');
MTMR.jnt_pub_ready = true;
end
%Pause for 5 seconds to let the ARMs home
%Need to implement and sub to listen to robot state and know when the arms
%are ready
pause(5);
end
end


%Callback for setting PSM1 publisher and subscribe
function radio_connect_to_psm1_cb(hObject,eventData,gui_handles)
global node PSM1;
if (get(hObject,'Value') == get(hObject,'Max'))
	display('Subscribing to PSM1 topic');
    PSM1.active = true;
    PSM1.jnt_sub = node.addSubscriber('/dvrk_psm/joint_position_current','sensor_msgs/JointState',10);
    PSM1.jnt_sub.addCustomMessageListener({@psm1_subscriber_cb,gui_handles});
    %Create snsr_msg/JS type message
    PSM1.jnt_msg = rosmatlab.message('sensor_msgs/JointState',node);
    display('Creating PSM1 Publisher');
    PSM1.jnt_pub = node.addPublisher('/dvrk_psm/set_position_joint','sensor_msgs/JointState');
    %Set the callback of PSM sliders to one function
    PSM1.state_msg = rosmatlab.message('std_msgs/String',node);
    PSM1.state_pub = node.addPublisher('/dvrk_psm/set_robot_state','std_msgs/String');
else
    PSM1.active = false;
	disp('Deleting PSM1 Subscriber Topic');
    node.removeSubscriber(PSM1.jnt_sub);
    disp('Deleting PSM1 Publisher');
    node.removePublisher(PSM1.jnt_pub);
    node.removePublisher(PSM1.state_pub);
    PSM1.jnt_pub_ready = false;
end
end

%Callback for setting PSM1 publisher and subscribe
function radio_connect_to_mtmr_cb(hObject,eventData,gui_handles)
global node MTMR;
if (get(hObject,'Value') == get(hObject,'Max'))
	display('Subscribing to MTMR topic');
    MTMR.active = true;
    MTMR.jnt_sub = node.addSubscriber('/dvrk_mtm/joint_position_current','sensor_msgs/JointState',10);
    MTMR.jnt_sub.addCustomMessageListener({@mtmr_subscriber_cb,gui_handles});
    %Create snsr_msg/JS type message
    MTMR.jnt_msg = rosmatlab.message('sensor_msgs/JointState',node);
    display('Creating MTMR Publisher');
    MTMR.jnt_pub = node.addPublisher('/dvrk_mtm/set_position_joint','sensor_msgs/JointState');
    %Set the callback of PSM sliders to one function
    MTMR.state_msg = rosmatlab.message('std_msgs/String',node);
    MTMR.state_pub = node.addPublisher('/dvrk_mtm/set_robot_state','std_msgs/String');
else
    MTMR.active = false;
	disp('Deleting MTMR Subscriber Topic');
    node.removeSubscriber(MTMR.jnt_sub);
    disp('Deleting MTMR Publisher');
    node.removePublisher(MTMR.jnt_pub);
    node.removePublisher(MTMR.state_pub);
    MTMR.jnt_pub_ready = false;
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


