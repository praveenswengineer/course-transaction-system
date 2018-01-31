/*
	@filename: LabSeven.cpp
	@program: LabSeven
	@author: Michael Valdron
	@date: November 25, 2014
*/
#include "stdafx.h"
#include "frmCourseChecker.h"

using namespace LabFive;

[STAThreadAttribute]
int main()
{
	// Enabling Windows XP visual effects before any controls are created
	Application::EnableVisualStyles();
	Application::SetCompatibleTextRenderingDefault(false); 

	// Create the main window and run it
	Application::Run(gcnew frmCourseChecker());
	return 0;
}
