%Developed By: Adnan Munawar (amunawar@wpi.edu)
%AIM Labs
%Worcester Poltechnic Institute (WPI)
function mtmr_pub_joint_pos(gui_handles)
global MTMR;  
    mtmr_set_jnt_names(gui_handles);
    mtmr_set_jnt_pos(gui_handles);
    %Finally Publish the message over the topic
    MTMR.pub.publish(MTMR.msg);
end


function mtmr_set_jnt_names(gui_handles)
global MTMR


%Do this for the first time only by checking if mtmr_pub_msg.getName is
%empty or not. This ensures that we are not wasting time setting the same
%joint names over and over again

if(MTMR.msg.getName.isEmpty == 1)
    
%hack to use psm1_pub_msg.setName(); Some bug doesnt allow the direct
%setting of Names to sensor_msgs/JointState. First set a temp variable called
%Name by calling getName. 
name = MTMR.msg.getName();

%Then add all the names to the temp variable
name.add('one_outer_yaw_joint');
name.add('one_outer_pitch_joint_1');
name.add('one_outer_insertion_joint');
name.add('one_outer_roll_joint');
name.add('one_outer_wrist_pitch_joint');
name.add('one_outer_wrist_yaw_joint');
name.add('one_outer_wrist_open_angle_joint_1');

%Now set the names to ros msg
MTMR.msg.setName(name);
%Also set the Names of Joints in the GUI (This also happens once)
mtmr_set_gui_jnt_names(gui_handles);

end
end

function mtmr_set_jnt_pos(gui_handles)
global MTMR

joint1 = get(gui_handles.slider1_mtmr,'Value');
joint2 = get(gui_handles.slider2_mtmr,'Value');
joint3 = get(gui_handles.slider3_mtmr,'Value');
joint4 = get(gui_handles.slider4_mtmr,'Value');
joint5 = get(gui_handles.slider5_mtmr,'Value');
joint6 = get(gui_handles.slider6_mtmr,'Value');
joint7 = get(gui_handles.slider7_mtmr,'Value');

MTMR.msg.setPosition([joint1,joint2,joint3,joint4,joint5,joint6,joint7]);
end

function mtmr_set_gui_jnt_names(gui_handles)
global MTMR;
if (MTMR.msg.getName.size ~= 7)
    disp('Setting GUI Jnt Names. Error! Number of Joint Names is not equal to 7');
else
set(gui_handles.text1_mtmr,'String',MTMR.msg.getName.get(0));
set(gui_handles.text2_mtmr,'String',MTMR.msg.getName.get(1));
set(gui_handles.text3_mtmr,'String',MTMR.msg.getName.get(2));
set(gui_handles.text4_mtmr,'String',MTMR.msg.getName.get(3));
set(gui_handles.text5_mtmr,'String',MTMR.msg.getName.get(4));
set(gui_handles.text6_mtmr,'String',MTMR.msg.getName.get(5));
set(gui_handles.text7_mtmr,'String',MTMR.msg.getName.get(6));
end
end