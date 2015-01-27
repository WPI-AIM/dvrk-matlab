classdef armBase < handle
    properties
        jnt_pub = [];
        jnt_sub = [];
        jnt_msg = []'
        state_pub = [];
        state_sub = [];
        state_msg = [];
        n_jnts = [];
        arm_type = [];
        node = [];
    end
    
    methods
        function obj = armBase(node,arm_type)
            if(strcmp(arm_type,'PSM1') || strcmp(arm_type,'PSM')...
                   || strcmp(arm_type,'psm1') || strcmp(arm_type,'psm'))
                obj.arm_type = obj.PSM1;
                obj.node = node;
            elseif(strcmp(arm_type,'MTMR') || strcmp(arm_type,'MTM')...
                   || strcmp(arm_type,'mtmr') || strcmp(arm_type,'mtm'))
               obj.arm_type = obj.MTMR;
               obj.node = node;
            else
                disp('Error: Arm type not recognized');
                disp('Valid Arm types are: MTMR MTM mtm mtmr PSM1 PSM psm psm1');
            end        
        end
    end
        
     enumeration
         PSM1, MTMR
     end
        
end
    
