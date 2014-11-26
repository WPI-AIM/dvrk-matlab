%Listening to Joint State Messages from PSM1
%By Adnan Munawar
node = rosmatlab.node('my_node');

h = rosio;
handles = guidata(h);
sub = rosmatlab.subscriber('/dvrk_psm/set_position_joint', ...
'std_msgs/String', 10, node);
sub.addCustomMessageListener({@sub_callback,handles});
pause(2);
for i=1:100
   disp('waiting');
   pause(0.5); 
end

