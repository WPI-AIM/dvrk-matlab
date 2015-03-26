classdef armBase < handle
    properties (SetAccess = private)
        jnt_pub = [];
        jnt_sub = [];
        jnt_msg = []'
        state_pub = [];
        state_sub = [];
        state_msg = [];
        arm_type = [];
        manip_state = [];
        n_jnts = [];
        node = [];
    end
    
    properties(Access = protected)
       jnt_sub_topic_name = '/dvrk_<ARM_TYPE>/joint_position_current';
       jnt_pub_topic_name = '/dvrk_<ARM_TYPE>/set_position_joint';
       state_sub_topic_name = '/dvrk_<ARM_TYPE>/robot_state_current';
       state_pub_topic_name = '/dvrk_<ARM_TYPE>/set_robot_state';
    end
    
    methods
        function obj = armBase(node,arm_type)
            if(strcmp(arm_type,'psm') || strcmp(arm_type,'PSM'))
                obj.arm_type = 'psm';
                obj.node = node;
            elseif(strcmp(arm_type,'psm1') || strcmp(arm_type,'PSM1'))
                obj.arm_type = 'psm1';
                obj.node = node;
            elseif(strcmp(arm_type,'psm2') || strcmp(arm_type,'PSM2'))
                obj.arm_type = 'psm2';
                obj.node = node;
            elseif(strcmp(arm_type,'mtm') || strcmp(arm_type,'MTM'))
               obj.arm_type = 'mtm';
               obj.node = node;
            elseif(strcmp(arm_type,'mtmr') || strcmp(arm_type,'MTMR'))
               obj.arm_type = 'mtmr';
               obj.node = node;
            elseif(strcmp(arm_type,'mtml') || strcmp(arm_type,'MTML'))
               obj.arm_type = 'mtml';
               obj.node = node;
            else
                disp('Error: Arm type not recognized');
                disp('Valid Arm types are: MTMR MTM mtm mtmr PSM1 PSM psm psm1');
            end        
        end
        
        function setupArm(obj)
            info_str = strcat('Setting up arm : ',obj.arm_type);
            disp(info_str);
            obj.jnt_sub = obj.node.addSubscriber(strrep(obj.jnt_sub_topic_name,'<ARM_TYPE>',obj.arm_type),'sensor_msgs/JointState',10);
            obj.jnt_sub.addCustomMessageListener({@jnt_sub_cb,obj});
            %Create snsr_msg/JS type message
            obj.jnt_msg = rosmatlab.message('sensor_msgs/JointState',obj.node);
            obj.jnt_pub = obj.node.addPublisher(strrep(obj.jnt_pub_topic_name,'<ARM_TYPE>',obj.arm_type),'sensor_msgs/JointState');
            %Set the callback of PSM sliders to one function
            obj.state_msg = rosmatlab.message('std_msgs/String',obj.node);
            obj.state_pub = obj.node.addPublisher(strrep(obj.state_pub_topic_name,'<ARM_TYPE>',obj.arm_type),'std_msgs/String');
            %Define the PSM1 state subscriber
            obj.state_sub = obj.node.addSubscriber(strrep(obj.state_sub_topic_name,'<ARM_TYPE>',obj.arm_type),'std_msgs/String',1);
            obj.state_sub.addCustomMessageListener({@state_sub_cb,obj});   
            end
                
        end
end
        
        

% Putting the Callback functions outside the main class since they don't
% work inside somehow !!!

function jnt_sub_cb(handle,event,obj)
message = event.JavaEvent.getSource;
obj.jnt_msg = message.getPosition;
end

function state_sub_cb(handle,event,obj)
message = event.JavaEvent.getSource;
obj.manip_state = message.getData;
end
    
