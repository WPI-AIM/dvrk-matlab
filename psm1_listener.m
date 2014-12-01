%Listening for Joint State Messages from PSM1
%By Adnan Munawar
node = rosmatlab.node('my_node');

global first_launch;
first_launch = 1;
h = rosio;
handles = guidata(h);
sub = rosmatlab.subscriber('/dvrk_psm/set_position_joint', ...
'sensor_msgs/JointState', 10, node);
sub.addCustomMessageListener({@sub_callback, handles});
pause(2);
for i=1:100
   disp('waiting');
   pause(0.5); 
end

