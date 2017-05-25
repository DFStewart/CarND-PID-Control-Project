# CarND-Controls-PID
Self-Driving Car Engineer Nanodegree Program

---

[//]: # (Image References)

[image1]: ./images/PID_equation.png "PID_EQ"
[image2]: ./images/PID_diagram.png "PID_DIAGRAM"
[image3]: ./images/kP_Tuning.png "KP_TUNE_PLOT"
[image4]: ./images/I_Error.png "IERR_PLOT"
[image5]: ./images/PIvsP.png "PIvsP_PLOT"
[image6]: ./images/D_Error.png "DERR_PLOT"
[image7]: ./images/PIvsPID.png "PIvsPID_PLOT"
[image8]: ./images/fine_tuning.png "FINE_TUNE"
[image9]: ./images/thr_ctrl_plot.png "THR_CTRL_PLOT"

# Write Up

In this project we utilize a PID controller to control a cars steering angle based primarily on CTE (cross track error) and speed to control a simulated vehicle's steering angle. The PID controller is visualized below in both equation and block diagram forms.

![alt text][image1]
![alt text][image2]

## Proportional Gain: kP
The proportional term is a gain applied to the CTE. The proportional term affects how fast the error is driven to zero. 

## Integral Gain: kI
The integral term is a gain applied to the integrated error. The integral term is used to remove steady state errors (biases). The integral term conceptually maintains a "history" of the error. The integral term can be very large depending upon the gain. 

## Derivative Gain: kD
The derivative term is a gain applied to the differentiated error. The derivative term is used for damping and reducing overshoot. The derivative term conceptually is a predictor of the (future) error.  

As a note closed loop stability I found exteremely important here as undamped oscillations are likely gain values that have shifted the poles of the system towards the right half plane and reduced the robustness and stability of the loop.

## Gain Tuning Methodology
I originally tried to use Ziegler-Nichols rules to tune the gains, but I found it difficult without the plant model. Instead my strategy for gain tuning was primarily manual, by first coarsely tuning the gains and then iterating, similar to the Twiddle method described in lecture. I chose the default throttle value of 0.3 for the tuning. 

Please see /matlab folder in this repository for scripts and data recorded from simulator to produce the attached plots.

My first step was to coarsely set kP while keeping kI and kD equal to zero. You can see in Figure 3 below that kP values between 0.01 and 0.1 do not immediately destabilize the control loop and cause underdamped oscillations. 

![alt text][image3]

I now had a coarse range for kP, but from the plots there is a clear steady state error. Adding a kI term will help remove steady state error, so it was the next term to add. I roughly set kP to 0.05 and moved to coarsely tuning kI. Integrator wind up was a serious problem as shown in Figure 4 below for different values of kI. I started with a very large kI value (0.01) and slowly decreased it until I reached a point where the system was not underdamped and oscillating too much and the I error term was not changing by too much.

![alt text][image4]

In Figure 5 below we see a comparison of the CTE for PI and P control. Both have significant oscillation that will require the kD term to reduce.

![alt text][image5]

Based on what I saw from the D_Error plots (Figure 6), D_error was the smallest and would require the largest gain in relation to the other two gains to have a significant effect. I found that a large gain of around 1.5 seemed to dampen some of the vibration and improve the controllers predictive capability as well as allow the car to complete the course without going off. 

![alt text][image6]

In Figure 7 below we see a comparison of the CTE for PI and PID control. Both have significant oscillation that will require the kD term to reduce.

![alt text][image7]

At this point I had a coarse range for each gain kP, kI and kD and I started refining, by increasing and decreasing the value by around 5-10% and observing the performance. The final parameters I achieved were 0.1, 0.0002 and 2.5 for the throttle setting of 0.3 case.

![alt text][image8]

A video of the system running with my final gains for throttle values of 0.3 is shown below:
https://youtu.be/N8VJKleY1KQ

## Increased Speeds

I tried to experiment with different speeds. My controller gains worked at different speeds to varying degrees. The car would complete the course, but there would often be significant oscillation. To combat this I attempted to implement a control system for the throttle based on the steering angle. My thought was to decrease the throttle linearly as a function of steering angle as shown in the plot below. After driving the vehicle by hand I determined empirically that about 15 deg (0.26 rad) of steering angle was the maximum required. Using this additional controller I found in the straightaways the car could travel faster. There is still significant oscillation, but it is able to complete the course.

![alt text][image9]

The throttle control is disabled as it is checked in now and throttle is hard coded to 0.3, but can be enabled by setting the throttle_control_enable to true in the main.cpp file. 

A video of the system running with the addition of throttle control using steering angle is shown below:
https://youtu.be/59h8g9nwt-s

## Further Improvements
To improve stability and error tracking one could try to compute gain and phase margins from a Bode plot. This would require a model of the system. Since this is a simulation, one likely exists, but since we do not have direct access, one could perform system identification by stimulating the system with different impulse responses. Assuming the model is linear (or linearize-able around steady state points), one could compute the closed loop transfer function and plot the frequency response in a Bode plot. This would be a good way to ensure stability of the system to prevent some of the underdamped oscillations that occur with some choices of gains. 

---

## Dependencies

* cmake >= 3.5
 * All OSes: [click here for installation instructions](https://cmake.org/install/)
* make >= 4.1
  * Linux: make is installed by default on most Linux distros
  * Mac: [install Xcode command line tools to get make](https://developer.apple.com/xcode/features/)
  * Windows: [Click here for installation instructions](http://gnuwin32.sourceforge.net/packages/make.htm)
* gcc/g++ >= 5.4
  * Linux: gcc / g++ is installed by default on most Linux distros
  * Mac: same deal as make - [install Xcode command line tools]((https://developer.apple.com/xcode/features/)
  * Windows: recommend using [MinGW](http://www.mingw.org/)
* [uWebSockets](https://github.com/uWebSockets/uWebSockets) == 0.13, but the master branch will probably work just fine
  * Follow the instructions in the [uWebSockets README](https://github.com/uWebSockets/uWebSockets/blob/master/README.md) to get setup for your platform. You can download the zip of the appropriate version from the [releases page](https://github.com/uWebSockets/uWebSockets/releases). Here's a link to the [v0.13 zip](https://github.com/uWebSockets/uWebSockets/archive/v0.13.0.zip).
  * If you run OSX and have homebrew installed you can just run the ./install-mac.sh script to install this
* Simulator. You can download these from the [project intro page](https://github.com/udacity/CarND-PID-Control-Project/releases) in the classroom.

## Basic Build Instructions

1. Clone this repo.
2. Make a build directory: `mkdir build && cd build`
3. Compile: `cmake .. && make`
4. Run it: `./pid`. 

## Editor Settings

We've purposefully kept editor configuration files out of this repo in order to
keep it as simple and environment agnostic as possible. However, we recommend
using the following settings:

* indent using spaces
* set tab width to 2 spaces (keeps the matrices in source code aligned)

## Code Style

Please (do your best to) stick to [Google's C++ style guide](https://google.github.io/styleguide/cppguide.html).

## Project Instructions and Rubric

Note: regardless of the changes you make, your project must be buildable using
cmake and make!

More information is only accessible by people who are already enrolled in Term 2
of CarND. If you are enrolled, see [the project page](https://classroom.udacity.com/nanodegrees/nd013/parts/40f38239-66b6-46ec-ae68-03afd8a601c8/modules/f1820894-8322-4bb3-81aa-b26b3c6dcbaf/lessons/e8235395-22dd-4b87-88e0-d108c5e5bbf4/concepts/6a4d8d42-6a04-4aa6-b284-1697c0fd6562)
for instructions and the project rubric.

## Hints!

* You don't have to follow this directory structure, but if you do, your work
  will span all of the .cpp files here. Keep an eye out for TODOs.

## Call for IDE Profiles Pull Requests

Help your fellow students!

We decided to create Makefiles with cmake to keep this project as platform
agnostic as possible. Similarly, we omitted IDE profiles in order to we ensure
that students don't feel pressured to use one IDE or another.

However! I'd love to help people get up and running with their IDEs of choice.
If you've created a profile for an IDE that you think other students would
appreciate, we'd love to have you add the requisite profile files and
instructions to ide_profiles/. For example if you wanted to add a VS Code
profile, you'd add:

* /ide_profiles/vscode/.vscode
* /ide_profiles/vscode/README.md

The README should explain what the profile does, how to take advantage of it,
and how to install it.

Frankly, I've never been involved in a project with multiple IDE profiles
before. I believe the best way to handle this would be to keep them out of the
repo root to avoid clutter. My expectation is that most profiles will include
instructions to copy files to a new location to get picked up by the IDE, but
that's just a guess.

One last note here: regardless of the IDE used, every submitted project must
still be compilable with cmake and make./
