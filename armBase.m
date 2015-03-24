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
    
    methods
        function obj = armBase(node,arm_type)
            if(strcmp(arm_type,'PSM1') || strcmp(arm_type,'PSM')...
                   || strcmp(arm_type,'psm1') || strcmp(arm_type,'psm'))
                obj.arm_type = 'PSM';
                obj.node = node;
            elseif(strcmp(arm_type,'MTMR') || strcmp(arm_type,'MTM')...
                   || strcmp(arm_type,'mtmr') || strcmp(arm_type,'mtm'))
               obj.arm_type = 'MTM';
               obj.node = node;
            else
                disp('Error: Arm type not recognized');
                disp('Valid Arm types are: MTMR MTM mtm mtmr PSM1 PSM psm psm1');
            end        
        end
        
        function setupArm(obj)
            switch obj.arm_type
                case 'PSM'
                    obj.setUpPSM();
            end
                
        end
    end
    
    methods (Access = private)
        function setUpPSM(obj)
            display('Subscribing to PSM1 topic');
            obj.jnt_sub = obj.node.addSubscriber('/dvrk_psm/joint_position_current','sensor_msgs/JointState',10);
            obj.jnt_sub.addCustomMessageListener({@psm1_subscriber_cb,obj});
            %Create snsr_msg/JS type message
            obj.jnt_msg = rosmatlab.message('sensor_msgs/JointState',obj.node);
            display('Creating PSM1 Publisher');
            obj.jnt_pub = obj.node.addPublisher('/dvrk_psm/set_position_joint','sensor_msgs/JointState');
            %Set the callback of PSM sliders to one function
            obj.state_msg = rosmatlab.message('std_msgs/String',obj.node);
            obj.state_pub = obj.node.addPublisher('/dvrk_psm/set_robot_state','std_msgs/String');
            %Define the PSM1 state subscriber
            obj.state_sub = obj.node.addSubscriber('/dvrk_psm/robot_state_current','std_msgs/String',1);
            obj.state_sub.addCustomMessageListener({@psm1_state_sub_cb,obj});
        end
        
    end
        
        
end

% Putting the Callback functions outside the main class since they don't
% work inside.

function psm1_subscriber_cb(handle,event,obj)
message = event.JavaEvent.getSource;
obj.jnt_msg = message.getPosition;
end

function psm1_state_sub_cb(handle,event,obj)
message = event.JavaEvent.getSource;
obj.manip_state = message.getData;
end
    
