#include "PID.h"
#include <iostream>
#include <fstream>
using namespace std;

PID::PID() {}

PID::~PID() {}

void PID::Init(double Kp_in, double Ki_in, double Kd_in)
{
	Kp = Kp_in; //proportional gain
	Ki = Ki_in; //integral gain
	Kd = Kd_in; //derivative gain

	p_error = 0.0;
	i_error = 0.0;
	d_error = 0.0;

	prevpass_cte = 0.0;
}

void PID::UpdateError(double cte)
{
	p_error = cte;
	i_error = i_error + cte;
	d_error = (cte - prevpass_cte);
	//
	prevpass_cte = cte;
}

double PID::TotalError()
{
	double output = 0.0;
	output = Kp*p_error + Ki * i_error + Kd * d_error;
	return output;
}

void PID::WriteTestData(double cte)
{
	ofstream outfile;
	outfile.open("testdata.csv", ios::app);
	outfile << cte << "," << p_error << "," << i_error << "," << d_error << "," << Kp << "," << Ki << "," << Kd << endl;
    outfile.close();
}

