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
end
% Set state_msg = "Home" and publish to specified topic
if (MTMR.active == true)
MTMR.state_msg.setData('Home');
MTMR.state_pub.publish(MTMR.state_msg);
display('Sending Home Command to MTMR');
end
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
    %Define the PSM1 state subscriber
    PSM1.state_sub = node.addSubscriber('/dvrk_psm/robot_state_current','std_msgs/String',1);
    PSM1.state_sub.addCustomMessageListener({@psm1_state_sub_cb,gui_handles});
else
    disp('Cleaning up PSM1 matlab structure');
    PSM1 = clean_up(PSM1);
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
    %Define the MTMR state subscriber
    MTMR.state_sub = node.addSubscriber('/dvrk_mtm/robot_state_current','std_msgs/String',1);
    MTMR.state_sub.addCustomMessageListener({@mtmr_state_sub_cb,gui_handles});
else
    disp('Cleaning up MTMR matlab structure');
    MTMR = clean_up(MTMR);
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

% Function Callback for setting PSM1 state 
function psm1_state_sub_cb(handle,event,gui_handles)
global PSM1
message = event.JavaEvent.getSource;
PSM1.manip_state = message.getData;
set(gui_handles.edit_psm1_state,'String',char(PSM1.manip_state));
end

% Function Callback for setting MTMR state
function mtmr_state_sub_cb(handle,event,gui_handles)
global MTMR
message = event.JavaEvent.getSource;
MTMR.manip_state = message.getData;
set(gui_handles.edit_mtmr_state,'String',char(MTMR.manip_state));
end


function arm_type =  clean_up(arm_type)
global node;
    arm_type.active = false;
    node.removeSubscriber(arm_type.jnt_sub);
    node.removeSubscriber(arm_type.state_sub);
    node.removePublisher(arm_type.jnt_pub);
    node.removePublisher(arm_type.state_pub);
    arm_type.manip_state = [];
end

