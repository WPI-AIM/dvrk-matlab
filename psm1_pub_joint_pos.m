%Developed By: Adnan Munawar (amunawar@wpi.edu)
%AIM Labs
%Worcester Poltechnic Institute (WPI)
function psm1_pub_joint_pos(gui_handles)
global PSM1;  
    psm1_set_jnt_names(gui_handles);
    psm1_set_jnt_pos(gui_handles);
    %Finally Publish the message over the topic
    PSM1.pub.publish(PSM1.msg);
end


function psm1_set_jnt_names(gui_handles)
global PSM1


%Do this for the first time only by checking if psm1_pub_msg.getName is
%empty or not. This ensures that we are not wasting time setting the same
%joint names over and over again

if(PSM1.msg.getName.isEmpty == 1)
    
%hack to use psm1_pub_msg.setName(); Some bug doesnt allow the direct
%setting of Names to sensor_msgs/JointState. First set a temp variable called
%Name by calling getName. 
name = PSM1.msg.getName();

%Then add all the names to the temp variable
name.add('one_outer_yaw_joint');
name.add('one_outer_pitch_joint_1');
name.add('one_outer_insertion_joint');
name.add('one_outer_roll_joint');
name.add('one_outer_wrist_pitch_joint');
name.add('one_outer_wrist_yaw_joint');
name.add('one_outer_wrist_open_angle_joint_1');

%Now set the names to ros msg
PSM1.msg.setName(name);
%Also set the Names of Joints in the GUI (This also happens once)
psm1_set_gui_jnt_names(gui_handles);

end
end

function psm1_set_jnt_pos(gui_handles)
global PSM1

joint1 = get(gui_handles.slider1_psm1,'Value');
joint2 = get(gui_handles.slider2_psm1,'Value');
joint3 = get(gui_handles.slider3_psm1,'Value');
joint4 = get(gui_handles.slider4_psm1,'Value');
joint5 = get(gui_handles.slider5_psm1,'Value');
joint6 = get(gui_handles.slider6_psm1,'Value');
joint7 = get(gui_handles.slider7_psm1,'Value');

PSM1.msg.setPosition([joint1,joint2,joint3,joint4,joint5,joint6,joint7]);
end

function psm1_set_gui_jnt_names(gui_handles)
global PSM1;
if (PSM1.msg.getName.size ~= 7)
    disp('Setting GUI Jnt Names. Error! Number of Joint Names is not equal to 7');
else
set(gui_handles.text1_psm1,'String',PSM1.msg.getName.get(0));
set(gui_handles.text2_psm1,'String',PSM1.msg.getName.get(1));
set(gui_handles.text3_psm1,'String',PSM1.msg.getName.get(2));
set(gui_handles.text4_psm1,'String',PSM1.msg.getName.get(3));
set(gui_handles.text5_psm1,'String',PSM1.msg.getName.get(4));
set(gui_handles.text6_psm1,'String',PSM1.msg.getName.get(5));
set(gui_handles.text7_psm1,'String',PSM1.msg.getName.get(6));
end
end