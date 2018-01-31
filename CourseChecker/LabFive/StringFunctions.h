/*
	@filename: StringFunctions.h
	@program: LabFive
	@author: Michael Valdron
	@date: November 10, 2014
*/
#pragma once

namespace StringFunctions {

	using namespace System;

	///<summary>This takes a string and validates it for a alpha value.</summary>
	bool IsLetter(String ^testString)
	{
		const char alphaArray[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
		'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
		bool isValid = true;
		int tempStorage = 0;
		int falseCount = 0;
		try
		{
			for each (char alphaChar in testString)
			{
				for (int i = 0; i < sizeof(alphaArray); i++)
				{
					if(alphaChar != alphaArray[i])
					{
						falseCount++;
					}
				}
				if(falseCount == sizeof(alphaArray))
				{
					throw gcnew Exception;
				}
				falseCount = 0;
			}
		}
		catch(Exception ^ex)
		{
			isValid = false;
		}

		return isValid;
	}
}