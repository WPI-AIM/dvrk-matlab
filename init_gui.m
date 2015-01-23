function init_gui(gui_handles)
global MTMR PSM1
%Make sure all the radio buttons set set to Low or (0) at the start.
set(gui_handles.radiobutton_connect_to_ros,'Value',0);
set(gui_handles.radiobutton_connect_to_mtml,'Value',0);
set(gui_handles.radiobutton_connect_to_mtmr,'Value',0);
set(gui_handles.radiobutton_connect_to_psm2,'Value',0);
set(gui_handles.radiobutton_connect_to_psm1,'Value',0);

MTMR.manip_state = 'NOT_CONNECTED';
PSM1.manip_state = 'NOT_CONNECTED';

set(gui_handles.edit_psm1_state,'String',PSM1.manip_state);
set(gui_handles.edit_mtmr_state,'String',MTMR.manip_state);
end