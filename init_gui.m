function init_gui(gui_handles)
%Make sure all the radio buttons set set to Low or (0) at the start.
set(gui_handles.radiobutton_connect_to_ros,'Value',0);
set(gui_handles.radiobutton_connect_to_mtml,'Value',0);
set(gui_handles.radiobutton_connect_to_mtmr,'Value',0);
set(gui_handles.radiobutton_connect_to_psm2,'Value',0);
set(gui_handles.radiobutton_connect_to_psm1,'Value',0);
end