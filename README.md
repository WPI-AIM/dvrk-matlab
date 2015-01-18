# dvrk-matlab
Matlab Interface for controlling dVRK. Requires dvrk-ros and its dependencies

**By: Adnan Munawar**-
**Worcester Polytechnic Institute**

 **HOW TO RUN THE CODE**
 * Make sure ROS is running, from the **dvrk_ros** package, you should either be running **test_dvrk_mtm.launch** file or **test_dvrk_psm.launch** file
 * Open the **dvrk_matlab_core.m** file
 * Run this file. A GUI window will open
  * a. Click **Connect to ROS Server** radio button. On a succesful connection, the button will read Connected!
  * b. **Select the ARM type** click the radio button. Only PSM1 and MTMR implemented for now.
    * Now you can control which ever arm you selected, using the sliders below and read their live joint positions in the text boxes
 * Uncheck the radio buttons of the ARM types to disconnect the ROS pub and sub. Can connect and disconnect without relaunching the code
 * To disconnect matlab_ros node, just unselect the Connect radio button. Can connect and disconnect without the need to relaunch the code
