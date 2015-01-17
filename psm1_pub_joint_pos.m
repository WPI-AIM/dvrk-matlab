function psm1_pub_joint_pos(gui_handles)
global psm1_pub psm1_pub_msg
     joint1 = get(gui_handles.slider1_psm1,'Value');
     joint2 = get(gui_handles.slider2_psm1,'Value');
     joint3 = get(gui_handles.slider3_psm1,'Value');
     joint4 = get(gui_handles.slider4_psm1,'Value');
     joint5 = get(gui_handles.slider5_psm1,'Value');
     joint6 = get(gui_handles.slider6_psm1,'Value');
     joint7 = get(gui_handles.slider7_psm1,'Value');
     
    psm1_pub_msg.setPosition([joint1,joint2,joint3,joint4,joint5,joint6,joint7]);
    psm1_pub.publish(psm1_pub_msg);
end