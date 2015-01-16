function assign_callbacks(fig_handle)
global node;
global psm1_sub psm2_sub mtmr_sub mtml_sub;
global psm1_pub psm2_pub mtmr_pub mtml_pub;

%Assign callback to each gui element in this function
set(fig_handle.radiobutton_connect_to_ros,'Callback',{@radio_connect_to_ros_cb});
set(fig_handle.radiobutton_connect_to_psm1,'Callback',{@radio_connect_to_psm1_cb});
end

%CallBack for Enabling connection to ROS

function radio_connect_to_ros_cb(hObject,evenData)
global node;
if (get(hObject,'Value') == get(hObject,'Max'))
	display('Connecting to ROS server, make sure ROS is running before hand');
    node = rosmatlab.node('/dvrk_matlab_core');
else
	display('Deleting Node');
    node.delete;
end
end

%Callback for setting PSM1 publisher and subscriber

function radio_connect_to_psm1_cb(hObject,eventData)
global node psm1_sub psm1_pub;
if (get(hObject,'Value') == get(hObject,'Max'))
	display('Subscribing to PSM1 topic');
    psm1_sub = node.addSubscriber('/dvrk_psm/joint_position_current','sensor_msgs/JointState',10);
    psm1_sub.setOnNewMessageListeners({@psm1_subscriber_cb});
else
	display('Deleting PSM1 Subscriber Topic');
    node.removeSubscriber(psm1_sub);
end
end

function psm1_subscriber_cb(msg)
msg.getName()
msg.getPosition()
end

