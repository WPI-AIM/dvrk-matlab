function assign_callbacks(gui_handle)
global node;
global psm1_sub psm2_sub mtmr_sub mtml_sub;
global psm1_pub psm2_pub mtmr_pub mtml_pub;
global psm1_pub_msg

%Assign callback to each gui element in this function
set(gui_handle.radiobutton_connect_to_ros,'Callback',{@radio_connect_to_ros_cb});
set(gui_handle.radiobutton_connect_to_psm1,'Callback',{@radio_connect_to_psm1_cb,gui_handle});
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

function radio_connect_to_psm1_cb(hObject,eventData,gui_handles)
global node psm1_sub psm1_pub psm1_pub_msg;
if (get(hObject,'Value') == get(hObject,'Max'))
	display('Subscribing to PSM1 topic');
    psm1_sub = node.addSubscriber('/dvrk_psm/joint_position_current','sensor_msgs/JointState',10);
    psm1_sub.addCustomMessageListener({@psm1_subscriber_cb,gui_handles});
    %Create snsr_msg/JS type message
    psm1_pub_msg = rosmatlab.message('sensor_msgs/JointState',node);
    display('Creating PSM1 Publisher');
    psm1_pub = node.addPublisher('/dvrk_psm/set_position_joint','sensor_msgs/JointState');
    %Set the callback of PSM sliders to one function
    set(gui_handles.slider1_psm1,'Callback',{@psm1_publisher_cb,gui_handles});
    set(gui_handles.slider2_psm1,'Callback',{@psm1_publisher_cb,gui_handles});
    set(gui_handles.slider3_psm1,'Callback',{@psm1_publisher_cb,gui_handles});
    set(gui_handles.slider4_psm1,'Callback',{@psm1_publisher_cb,gui_handles});
    set(gui_handles.slider5_psm1,'Callback',{@psm1_publisher_cb,gui_handles});
    set(gui_handles.slider6_psm1,'Callback',{@psm1_publisher_cb,gui_handles});
    set(gui_handles.slider7_psm1,'Callback',{@psm1_publisher_cb,gui_handles});
else
	display('Deleting PSM1 Subscriber Topic');
    node.removeSubscriber(psm1_sub);
end
end

function psm1_subscriber_cb(handle,event,gui_handles)
message = event.JavaEvent.getSource;
currPosition = message.getPosition;
set(gui_handles.edit1_psm,'String',num2str(currPosition(1)));
set(gui_handles.edit2_psm,'String',num2str(currPosition(2)));
set(gui_handles.edit3_psm,'String',num2str(currPosition(3)));
set(gui_handles.edit4_psm,'String',num2str(currPosition(4)));
set(gui_handles.edit5_psm,'String',num2str(currPosition(5)));
set(gui_handles.edit6_psm,'String',num2str(currPosition(6)));
set(gui_handles.edit7_psm,'String',num2str(currPosition(7)));
end

function psm1_publisher_cb(hObject,eventData,gui_handles)
global psm1_pub psm1_pub_msg;
     joint1 = get(gui_handles.slider1_psm1,'Value');
     joint2 = get(gui_handles.slider2_psm1,'Value');
     joint3 = get(gui_handles.slider3_psm1,'Value');
     joint4 = get(gui_handles.slider4_psm1,'Value');
     joint5 = get(gui_handles.slider5_psm1,'Value');
     joint6 = get(gui_handles.slider6_psm1,'Value');
     joint7 = get(gui_handles.slider7_psm1,'Value');
     
     psm1_pub_msg.setPosition([joint1,joint2,joint3,joint4,joint5,joint6,joint7]);
     psm1_pub.publish(psm1_pub_msg);
     pause(0.001);
end

