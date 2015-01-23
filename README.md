# dvrk-matlab
Matlab Interface for controlling dVRK. Requires dvrk-ros and its dependencies

**By: Adnan Munawar**-
**Worcester Polytechnic Institute**


 **Requirements**
  * Matlab ROS IO must be installed. 
   * Go to http://www.mathworks.com/hardware-support/robot-operating-system.html?refresh=true
   * Download the Matlab ROS IO for your system and follow the instructions to install. If there is any issue with installation, let me know, I know about most of the issues and can help you set it up in most cases
   * After succesful installation, try running a few examples from documentation to see you have set up Matlab ROS IO correctly.
  * You should have the **dvrk_ros** package (and it's **CISST** and **SAW** requirements) installed and working. 
  * Just to make sure MATLAB nodes can communicate to ROS core, you should have set the **ROS_HOSTNAME** and **ROS_MATER_URI** environment variables. To do so for all the shells:
   * Open terminal
   * Type gedit ~/.bashrc
   * Add the following two lines at the end
    * export ROS_HOSTNAME=localhost
    * export ROS_MASTER_URI=http://localhost:11311
   * Save the file. Reload your shell

**HOW TO RUN THE CODE**
 * Make sure ROS is running, from the **dvrk_ros** package, you should either be running **test_dvrk_mtm.launch** file or **test_dvrk_psm.launch** file
 * Open the **dvrk_matlab_core.m** file
 * Run this file. A GUI window will open
  * a. Click **Connect to ROS Server** radio button. On a succesful connection, the button will read Connected!
  * b. **Select the ARM type** click the radio button. Only PSM1 and MTMR implemented for now.
  * c. If the ARM is already homed, you can control the corresponding arm. If not, click "Home" button to home any manipulator connected. You can only control a manipulator if it has been homed. The robot state listener is implemented that continuously listens to the current state of robot and updates it in the edit field below the manipulator radio button.
    * Now you can control which ever arm you selected, using the sliders below and read their live joint positions in the text boxes
 * Uncheck the radio buttons of the ARM types to disconnect the ROS pub and sub. Can connect and disconnect without relaunching the code
 * To disconnect matlab_ros node, just unselect the Connect radio button. Can connect and disconnect without the need to relaunch the code
