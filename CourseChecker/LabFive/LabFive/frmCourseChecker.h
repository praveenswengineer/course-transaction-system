/*
	@filename: frmCourseChecker.h
	@program: LabFive
	@author: Michael Valdron
	@date: November 10, 2014
*/
#pragma once

#include "StringFunctions.h"


namespace LabFive {

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;
	using namespace CclECILib;
	using namespace StringFunctions;

	/// <summary>
	/// Summary for Form1
	/// </summary>
	public ref class frmCourseChecker : public System::Windows::Forms::Form
	{
	public:
		frmCourseChecker(void)
		{
			InitializeComponent();
		}

	protected:
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		~frmCourseChecker()
		{
			if (components)
			{
				delete components;
			}
			delete ECI;
			delete connection;
			delete flow;
			delete buffer;
			delete uow;
		}
	private: System::Windows::Forms::Label^  lblTitle;
	private: System::Windows::Forms::Label^  lblCourseCode;
	private: System::Windows::Forms::TextBox^  txtCourseCode;
	private: System::Windows::Forms::Label^  lblCourseDescription;
	private: System::Windows::Forms::Label^  lblCourseDescriptionOutput;
	private: System::Windows::Forms::Label^  lblDescription;
	private: System::Windows::Forms::Button^  btnReset;
	private: System::Windows::Forms::Button^  btnGo;
	private: System::Windows::Forms::Button^  btnExit;
	private: System::ComponentModel::IContainer^  components;


	protected: 

	private:
		/// <summary>
		/// Required designer variable.
		/// </summary>

		CclOECIClass ^ECI;
		CclOConnClass ^connection;
		CclOBufClass ^buffer;
		CclOFlowClass ^flow;
	private: System::Windows::Forms::ToolTip^  CCToolTips;
			 CclOUOWClass ^uow;

#pragma region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		void InitializeComponent(void)
		{
			this->components = (gcnew System::ComponentModel::Container());
			this->lblTitle = (gcnew System::Windows::Forms::Label());
			this->lblCourseCode = (gcnew System::Windows::Forms::Label());
			this->txtCourseCode = (gcnew System::Windows::Forms::TextBox());
			this->lblCourseDescription = (gcnew System::Windows::Forms::Label());
			this->lblCourseDescriptionOutput = (gcnew System::Windows::Forms::Label());
			this->lblDescription = (gcnew System::Windows::Forms::Label());
			this->btnReset = (gcnew System::Windows::Forms::Button());
			this->btnGo = (gcnew System::Windows::Forms::Button());
			this->btnExit = (gcnew System::Windows::Forms::Button());
			this->CCToolTips = (gcnew System::Windows::Forms::ToolTip(this->components));
			this->SuspendLayout();
			// 
			// lblTitle
			// 
			this->lblTitle->AutoSize = true;
			this->lblTitle->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 12, System::Drawing::FontStyle::Regular, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->lblTitle->Location = System::Drawing::Point(153, 31);
			this->lblTitle->Name = L"lblTitle";
			this->lblTitle->Size = System::Drawing::Size(185, 20);
			this->lblTitle->TabIndex = 0;
			this->lblTitle->Text = L"Course Checker - Lab #5";
			// 
			// lblCourseCode
			// 
			this->lblCourseCode->AutoSize = true;
			this->lblCourseCode->Location = System::Drawing::Point(109, 91);
			this->lblCourseCode->Name = L"lblCourseCode";
			this->lblCourseCode->Size = System::Drawing::Size(71, 13);
			this->lblCourseCode->TabIndex = 1;
			this->lblCourseCode->Text = L"Course Code:";
			// 
			// txtCourseCode
			// 
			this->txtCourseCode->Location = System::Drawing::Point(186, 88);
			this->txtCourseCode->MaxLength = 8;
			this->txtCourseCode->Name = L"txtCourseCode";
			this->txtCourseCode->Size = System::Drawing::Size(100, 20);
			this->txtCourseCode->TabIndex = 2;
			this->CCToolTips->SetToolTip(this->txtCourseCode, L"Enter the course code here.");
			this->txtCourseCode->TextChanged += gcnew System::EventHandler(this, &frmCourseChecker::txtCourseCode_TextChanged);
			// 
			// lblCourseDescription
			// 
			this->lblCourseDescription->AutoSize = true;
			this->lblCourseDescription->Location = System::Drawing::Point(81, 155);
			this->lblCourseDescription->Name = L"lblCourseDescription";
			this->lblCourseDescription->Size = System::Drawing::Size(99, 13);
			this->lblCourseDescription->TabIndex = 3;
			this->lblCourseDescription->Text = L"Course Description:";
			// 
			// lblCourseDescriptionOutput
			// 
			this->lblCourseDescriptionOutput->ImageAlign = System::Drawing::ContentAlignment::MiddleLeft;
			this->lblCourseDescriptionOutput->Location = System::Drawing::Point(183, 151);
			this->lblCourseDescriptionOutput->Name = L"lblCourseDescriptionOutput";
			this->lblCourseDescriptionOutput->Size = System::Drawing::Size(128, 20);
			this->lblCourseDescriptionOutput->TabIndex = 4;
			this->lblCourseDescriptionOutput->TextAlign = System::Drawing::ContentAlignment::MiddleCenter;
			this->CCToolTips->SetToolTip(this->lblCourseDescriptionOutput, L"Displays the description of the course.");
			// 
			// lblDescription
			// 
			this->lblDescription->AutoSize = true;
			this->lblDescription->Font = (gcnew System::Drawing::Font(L"Microsoft Sans Serif", 12, System::Drawing::FontStyle::Regular, System::Drawing::GraphicsUnit::Point, 
				static_cast<System::Byte>(0)));
			this->lblDescription->Location = System::Drawing::Point(153, 190);
			this->lblDescription->Name = L"lblDescription";
			this->lblDescription->Size = System::Drawing::Size(174, 20);
			this->lblDescription->TabIndex = 5;
			this->lblDescription->Text = L"Here is your description";
			this->CCToolTips->SetToolTip(this->lblDescription, L"Displays messages.");
			// 
			// btnReset
			// 
			this->btnReset->DialogResult = System::Windows::Forms::DialogResult::Cancel;
			this->btnReset->Location = System::Drawing::Point(112, 219);
			this->btnReset->Name = L"btnReset";
			this->btnReset->Size = System::Drawing::Size(68, 41);
			this->btnReset->TabIndex = 6;
			this->btnReset->Text = L"Reset";
			this->CCToolTips->SetToolTip(this->btnReset, L"Click here to resets the form.");
			this->btnReset->UseVisualStyleBackColor = true;
			this->btnReset->Click += gcnew System::EventHandler(this, &frmCourseChecker::btnReset_Click);
			// 
			// btnGo
			// 
			this->btnGo->Location = System::Drawing::Point(218, 219);
			this->btnGo->Name = L"btnGo";
			this->btnGo->Size = System::Drawing::Size(68, 41);
			this->btnGo->TabIndex = 7;
			this->btnGo->Text = L"Go";
			this->CCToolTips->SetToolTip(this->btnGo, L"Click here to get course information.");
			this->btnGo->UseVisualStyleBackColor = true;
			this->btnGo->Click += gcnew System::EventHandler(this, &frmCourseChecker::btnGo_Click);
			// 
			// btnExit
			// 
			this->btnExit->Location = System::Drawing::Point(321, 219);
			this->btnExit->Name = L"btnExit";
			this->btnExit->Size = System::Drawing::Size(68, 41);
			this->btnExit->TabIndex = 8;
			this->btnExit->Text = L"Exit";
			this->CCToolTips->SetToolTip(this->btnExit, L"Click here to close form.");
			this->btnExit->UseVisualStyleBackColor = true;
			this->btnExit->Click += gcnew System::EventHandler(this, &frmCourseChecker::btnExit_Click);
			// 
			// frmCourseChecker
			// 
			this->AcceptButton = this->btnGo;
			this->AutoScaleDimensions = System::Drawing::SizeF(6, 13);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->CancelButton = this->btnReset;
			this->ClientSize = System::Drawing::Size(504, 272);
			this->Controls->Add(this->btnExit);
			this->Controls->Add(this->btnGo);
			this->Controls->Add(this->btnReset);
			this->Controls->Add(this->lblDescription);
			this->Controls->Add(this->lblCourseDescriptionOutput);
			this->Controls->Add(this->lblCourseDescription);
			this->Controls->Add(this->txtCourseCode);
			this->Controls->Add(this->lblCourseCode);
			this->Controls->Add(this->lblTitle);
			this->FormBorderStyle = System::Windows::Forms::FormBorderStyle::Fixed3D;
			this->MaximizeBox = false;
			this->Name = L"frmCourseChecker";
			this->StartPosition = System::Windows::Forms::FormStartPosition::CenterScreen;
			this->Text = L"Course Checker";
			this->Load += gcnew System::EventHandler(this, &frmCourseChecker::frmCourseChecker_Load);
			this->ResumeLayout(false);
			this->PerformLayout();

		}
#pragma endregion
	private: 
	System::Void btnGo_Click(System::Object^  sender, System::EventArgs^  e) 
	{
		const int charCount = 4;
		int tempStorage;

		if (txtCourseCode->Text->Length != 8)
		{
			MessageBox::Show("Course code must have 8 characters.");
			txtCourseCode->Focus();
			txtCourseCode->SelectAll();
		}
		else
		{

			if (!IsLetter(txtCourseCode->Text))
			{
				MessageBox::Show("First four characters should be upper case letters.");
				txtCourseCode->Focus();
				txtCourseCode->Select(0,4);
			}
			else if (!Int32::TryParse(txtCourseCode->Text->Substring(4,4),tempStorage))
			{
				MessageBox::Show("Second four characters should be numeric.");
				txtCourseCode->Focus();
				txtCourseCode->Select(4,4);
			}
			else
			{
				try
				{
					buffer->SetString(txtCourseCode->Text + lblCourseDescriptionOutput->Text);
					buffer->SetLength(25);
		
		
					connection->Link(flow, "MVPRGCC", buffer, uow);
					lblCourseDescriptionOutput->Text = buffer->String()->Substring(8,17);
					if (buffer->String()->Substring(8,17) == "COURSE NOT FOUND ")
					{
						lblDescription->Text = "The course code you entered does not exist.";
					}
					uow->Commit(flow);
					txtCourseCode->Focus();
				}
				catch (Exception ^ex)
				{
					MessageBox::Show(ex->Message);
					txtCourseCode->Focus();
					txtCourseCode->SelectAll();
				}
			}
		}
	}
    System::Void frmCourseChecker_Load(System::Object^  sender, System::EventArgs^  e) 
    {
		ECI = gcnew CclOECIClass;
		connection = gcnew CclOConnClass;
		buffer = gcnew CclOBufClass;
		flow = gcnew CclOFlowClass;
		uow = gcnew CclOUOWClass;

		connection->Details("Infinity", "STUDENT", "STUDENT");
    }
    System::Void btnReset_Click(System::Object^  sender, System::EventArgs^  e) 
    {
		txtCourseCode->Clear();
		lblCourseDescriptionOutput->Text = "";
		lblDescription->Text = "";
		txtCourseCode->Focus();
    }
    System::Void btnExit_Click(System::Object^  sender, System::EventArgs^  e) 
	{
		this->Close();
	}
    System::Void txtCourseCode_TextChanged(System::Object^  sender, System::EventArgs^  e) 
	{
		lblCourseDescriptionOutput->Text = "";
		lblDescription->Text = "";
	}
};
}

