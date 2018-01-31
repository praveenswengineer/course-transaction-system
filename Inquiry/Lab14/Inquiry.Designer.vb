<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmInquiry
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.lblInquiry = New System.Windows.Forms.Label()
        Me.lblStudentNumber = New System.Windows.Forms.Label()
        Me.txtStudentNumber = New System.Windows.Forms.TextBox()
        Me.lblMessage = New System.Windows.Forms.Label()
        Me.btnConnection = New System.Windows.Forms.Button()
        Me.btnClear = New System.Windows.Forms.Button()
        Me.btnExit = New System.Windows.Forms.Button()
        Me.btnInquire = New System.Windows.Forms.Button()
        Me.gpbCourseCodes = New System.Windows.Forms.GroupBox()
        Me.lblCCFive = New System.Windows.Forms.Label()
        Me.lblCCFour = New System.Windows.Forms.Label()
        Me.lblCCThree = New System.Windows.Forms.Label()
        Me.lblCCTwo = New System.Windows.Forms.Label()
        Me.lblCCOne = New System.Windows.Forms.Label()
        Me.lblNumberFive = New System.Windows.Forms.Label()
        Me.lblNumberFour = New System.Windows.Forms.Label()
        Me.lblNumberThree = New System.Windows.Forms.Label()
        Me.lblNumberTwo = New System.Windows.Forms.Label()
        Me.lblNumberOne = New System.Windows.Forms.Label()
        Me.gpbContactInfo = New System.Windows.Forms.GroupBox()
        Me.lblPhoneNumber = New System.Windows.Forms.Label()
        Me.lblPostalCode = New System.Windows.Forms.Label()
        Me.lblAddressThree = New System.Windows.Forms.Label()
        Me.lblAddressTwo = New System.Windows.Forms.Label()
        Me.lblAddressOne = New System.Windows.Forms.Label()
        Me.lblStudentName = New System.Windows.Forms.Label()
        Me.lblPhoneNumberText = New System.Windows.Forms.Label()
        Me.lblPostalCodeText = New System.Windows.Forms.Label()
        Me.lblAddressText = New System.Windows.Forms.Label()
        Me.lblNameText = New System.Windows.Forms.Label()
        Me.gpbCourseCodes.SuspendLayout()
        Me.gpbContactInfo.SuspendLayout()
        Me.SuspendLayout()
        '
        'lblInquiry
        '
        Me.lblInquiry.AutoSize = True
        Me.lblInquiry.Font = New System.Drawing.Font("Microsoft Sans Serif", 15.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblInquiry.Location = New System.Drawing.Point(338, 9)
        Me.lblInquiry.Name = "lblInquiry"
        Me.lblInquiry.Size = New System.Drawing.Size(150, 25)
        Me.lblInquiry.TabIndex = 0
        Me.lblInquiry.Text = "Inquiry Screen"
        '
        'lblStudentNumber
        '
        Me.lblStudentNumber.AutoSize = True
        Me.lblStudentNumber.Location = New System.Drawing.Point(252, 53)
        Me.lblStudentNumber.Name = "lblStudentNumber"
        Me.lblStudentNumber.Size = New System.Drawing.Size(87, 13)
        Me.lblStudentNumber.TabIndex = 1
        Me.lblStudentNumber.Text = "Student Number:"
        '
        'txtStudentNumber
        '
        Me.txtStudentNumber.Location = New System.Drawing.Point(345, 50)
        Me.txtStudentNumber.MaxLength = 7
        Me.txtStudentNumber.Name = "txtStudentNumber"
        Me.txtStudentNumber.Size = New System.Drawing.Size(143, 20)
        Me.txtStudentNumber.TabIndex = 2
        '
        'lblMessage
        '
        Me.lblMessage.AutoSize = True
        Me.lblMessage.ForeColor = System.Drawing.Color.Green
        Me.lblMessage.Location = New System.Drawing.Point(505, 53)
        Me.lblMessage.Name = "lblMessage"
        Me.lblMessage.Size = New System.Drawing.Size(167, 13)
        Me.lblMessage.TabIndex = 3
        Me.lblMessage.Text = "Enter a student number to search."
        '
        'btnConnection
        '
        Me.btnConnection.Location = New System.Drawing.Point(255, 90)
        Me.btnConnection.Name = "btnConnection"
        Me.btnConnection.Size = New System.Drawing.Size(75, 37)
        Me.btnConnection.TabIndex = 4
        Me.btnConnection.Text = "Disconnect"
        Me.btnConnection.UseVisualStyleBackColor = True
        '
        'btnClear
        '
        Me.btnClear.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnClear.Location = New System.Drawing.Point(336, 90)
        Me.btnClear.Name = "btnClear"
        Me.btnClear.Size = New System.Drawing.Size(75, 37)
        Me.btnClear.TabIndex = 5
        Me.btnClear.Text = "Clear"
        Me.btnClear.UseVisualStyleBackColor = True
        '
        'btnExit
        '
        Me.btnExit.Enabled = False
        Me.btnExit.Location = New System.Drawing.Point(417, 90)
        Me.btnExit.Name = "btnExit"
        Me.btnExit.Size = New System.Drawing.Size(75, 37)
        Me.btnExit.TabIndex = 6
        Me.btnExit.Text = "Exit"
        Me.btnExit.UseVisualStyleBackColor = True
        '
        'btnInquire
        '
        Me.btnInquire.Location = New System.Drawing.Point(498, 90)
        Me.btnInquire.Name = "btnInquire"
        Me.btnInquire.Size = New System.Drawing.Size(75, 37)
        Me.btnInquire.TabIndex = 7
        Me.btnInquire.Text = "Inquire"
        Me.btnInquire.UseVisualStyleBackColor = True
        '
        'gpbCourseCodes
        '
        Me.gpbCourseCodes.Controls.Add(Me.lblCCFive)
        Me.gpbCourseCodes.Controls.Add(Me.lblCCFour)
        Me.gpbCourseCodes.Controls.Add(Me.lblCCThree)
        Me.gpbCourseCodes.Controls.Add(Me.lblCCTwo)
        Me.gpbCourseCodes.Controls.Add(Me.lblCCOne)
        Me.gpbCourseCodes.Controls.Add(Me.lblNumberFive)
        Me.gpbCourseCodes.Controls.Add(Me.lblNumberFour)
        Me.gpbCourseCodes.Controls.Add(Me.lblNumberThree)
        Me.gpbCourseCodes.Controls.Add(Me.lblNumberTwo)
        Me.gpbCourseCodes.Controls.Add(Me.lblNumberOne)
        Me.gpbCourseCodes.Location = New System.Drawing.Point(12, 167)
        Me.gpbCourseCodes.Name = "gpbCourseCodes"
        Me.gpbCourseCodes.Size = New System.Drawing.Size(327, 158)
        Me.gpbCourseCodes.TabIndex = 8
        Me.gpbCourseCodes.TabStop = False
        Me.gpbCourseCodes.Text = "Course Codes"
        Me.gpbCourseCodes.Visible = False
        '
        'lblCCFive
        '
        Me.lblCCFive.AutoSize = True
        Me.lblCCFive.Location = New System.Drawing.Point(29, 117)
        Me.lblCCFive.Name = "lblCCFive"
        Me.lblCCFive.Size = New System.Drawing.Size(39, 13)
        Me.lblCCFive.TabIndex = 9
        Me.lblCCFive.Text = "Label1"
        '
        'lblCCFour
        '
        Me.lblCCFour.AutoSize = True
        Me.lblCCFour.Location = New System.Drawing.Point(29, 93)
        Me.lblCCFour.Name = "lblCCFour"
        Me.lblCCFour.Size = New System.Drawing.Size(39, 13)
        Me.lblCCFour.TabIndex = 8
        Me.lblCCFour.Text = "Label1"
        '
        'lblCCThree
        '
        Me.lblCCThree.AutoSize = True
        Me.lblCCThree.Location = New System.Drawing.Point(29, 69)
        Me.lblCCThree.Name = "lblCCThree"
        Me.lblCCThree.Size = New System.Drawing.Size(39, 13)
        Me.lblCCThree.TabIndex = 7
        Me.lblCCThree.Text = "Label1"
        '
        'lblCCTwo
        '
        Me.lblCCTwo.AutoSize = True
        Me.lblCCTwo.Location = New System.Drawing.Point(29, 46)
        Me.lblCCTwo.Name = "lblCCTwo"
        Me.lblCCTwo.Size = New System.Drawing.Size(39, 13)
        Me.lblCCTwo.TabIndex = 6
        Me.lblCCTwo.Text = "Label1"
        '
        'lblCCOne
        '
        Me.lblCCOne.AutoSize = True
        Me.lblCCOne.Location = New System.Drawing.Point(29, 20)
        Me.lblCCOne.Name = "lblCCOne"
        Me.lblCCOne.Size = New System.Drawing.Size(39, 13)
        Me.lblCCOne.TabIndex = 5
        Me.lblCCOne.Text = "Label1"
        '
        'lblNumberFive
        '
        Me.lblNumberFive.AutoSize = True
        Me.lblNumberFive.Location = New System.Drawing.Point(7, 117)
        Me.lblNumberFive.Name = "lblNumberFive"
        Me.lblNumberFive.Size = New System.Drawing.Size(16, 13)
        Me.lblNumberFive.TabIndex = 4
        Me.lblNumberFive.Text = "5)"
        '
        'lblNumberFour
        '
        Me.lblNumberFour.AutoSize = True
        Me.lblNumberFour.Location = New System.Drawing.Point(7, 93)
        Me.lblNumberFour.Name = "lblNumberFour"
        Me.lblNumberFour.Size = New System.Drawing.Size(16, 13)
        Me.lblNumberFour.TabIndex = 3
        Me.lblNumberFour.Text = "4)"
        '
        'lblNumberThree
        '
        Me.lblNumberThree.AutoSize = True
        Me.lblNumberThree.Location = New System.Drawing.Point(7, 69)
        Me.lblNumberThree.Name = "lblNumberThree"
        Me.lblNumberThree.Size = New System.Drawing.Size(16, 13)
        Me.lblNumberThree.TabIndex = 2
        Me.lblNumberThree.Text = "3)"
        '
        'lblNumberTwo
        '
        Me.lblNumberTwo.AutoSize = True
        Me.lblNumberTwo.Location = New System.Drawing.Point(7, 46)
        Me.lblNumberTwo.Name = "lblNumberTwo"
        Me.lblNumberTwo.Size = New System.Drawing.Size(16, 13)
        Me.lblNumberTwo.TabIndex = 1
        Me.lblNumberTwo.Text = "2)"
        '
        'lblNumberOne
        '
        Me.lblNumberOne.AutoSize = True
        Me.lblNumberOne.Location = New System.Drawing.Point(7, 20)
        Me.lblNumberOne.Name = "lblNumberOne"
        Me.lblNumberOne.Size = New System.Drawing.Size(16, 13)
        Me.lblNumberOne.TabIndex = 0
        Me.lblNumberOne.Text = "1)"
        '
        'gpbContactInfo
        '
        Me.gpbContactInfo.Controls.Add(Me.lblPhoneNumber)
        Me.gpbContactInfo.Controls.Add(Me.lblPostalCode)
        Me.gpbContactInfo.Controls.Add(Me.lblAddressThree)
        Me.gpbContactInfo.Controls.Add(Me.lblAddressTwo)
        Me.gpbContactInfo.Controls.Add(Me.lblAddressOne)
        Me.gpbContactInfo.Controls.Add(Me.lblStudentName)
        Me.gpbContactInfo.Controls.Add(Me.lblPhoneNumberText)
        Me.gpbContactInfo.Controls.Add(Me.lblPostalCodeText)
        Me.gpbContactInfo.Controls.Add(Me.lblAddressText)
        Me.gpbContactInfo.Controls.Add(Me.lblNameText)
        Me.gpbContactInfo.Location = New System.Drawing.Point(495, 167)
        Me.gpbContactInfo.Name = "gpbContactInfo"
        Me.gpbContactInfo.Size = New System.Drawing.Size(327, 158)
        Me.gpbContactInfo.TabIndex = 9
        Me.gpbContactInfo.TabStop = False
        Me.gpbContactInfo.Text = "Contact Info"
        Me.gpbContactInfo.Visible = False
        '
        'lblPhoneNumber
        '
        Me.lblPhoneNumber.AutoSize = True
        Me.lblPhoneNumber.Location = New System.Drawing.Point(93, 133)
        Me.lblPhoneNumber.Name = "lblPhoneNumber"
        Me.lblPhoneNumber.Size = New System.Drawing.Size(39, 13)
        Me.lblPhoneNumber.TabIndex = 9
        Me.lblPhoneNumber.Text = "Label1"
        '
        'lblPostalCode
        '
        Me.lblPostalCode.AutoSize = True
        Me.lblPostalCode.Location = New System.Drawing.Point(93, 111)
        Me.lblPostalCode.Name = "lblPostalCode"
        Me.lblPostalCode.Size = New System.Drawing.Size(39, 13)
        Me.lblPostalCode.TabIndex = 8
        Me.lblPostalCode.Text = "Label1"
        '
        'lblAddressThree
        '
        Me.lblAddressThree.AutoSize = True
        Me.lblAddressThree.Location = New System.Drawing.Point(93, 93)
        Me.lblAddressThree.Name = "lblAddressThree"
        Me.lblAddressThree.Size = New System.Drawing.Size(39, 13)
        Me.lblAddressThree.TabIndex = 7
        Me.lblAddressThree.Text = "Label1"
        '
        'lblAddressTwo
        '
        Me.lblAddressTwo.AutoSize = True
        Me.lblAddressTwo.Location = New System.Drawing.Point(93, 69)
        Me.lblAddressTwo.Name = "lblAddressTwo"
        Me.lblAddressTwo.Size = New System.Drawing.Size(39, 13)
        Me.lblAddressTwo.TabIndex = 6
        Me.lblAddressTwo.Text = "Label1"
        '
        'lblAddressOne
        '
        Me.lblAddressOne.AutoSize = True
        Me.lblAddressOne.Location = New System.Drawing.Point(93, 46)
        Me.lblAddressOne.Name = "lblAddressOne"
        Me.lblAddressOne.Size = New System.Drawing.Size(39, 13)
        Me.lblAddressOne.TabIndex = 5
        Me.lblAddressOne.Text = "Label1"
        '
        'lblStudentName
        '
        Me.lblStudentName.AutoSize = True
        Me.lblStudentName.Location = New System.Drawing.Point(93, 16)
        Me.lblStudentName.Name = "lblStudentName"
        Me.lblStudentName.Size = New System.Drawing.Size(39, 13)
        Me.lblStudentName.TabIndex = 4
        Me.lblStudentName.Text = "Label1"
        '
        'lblPhoneNumberText
        '
        Me.lblPhoneNumberText.AutoSize = True
        Me.lblPhoneNumberText.Location = New System.Drawing.Point(6, 133)
        Me.lblPhoneNumberText.Name = "lblPhoneNumberText"
        Me.lblPhoneNumberText.Size = New System.Drawing.Size(81, 13)
        Me.lblPhoneNumberText.TabIndex = 3
        Me.lblPhoneNumberText.Text = "Phone Number:"
        '
        'lblPostalCodeText
        '
        Me.lblPostalCodeText.AutoSize = True
        Me.lblPostalCodeText.Location = New System.Drawing.Point(6, 111)
        Me.lblPostalCodeText.Name = "lblPostalCodeText"
        Me.lblPostalCodeText.Size = New System.Drawing.Size(67, 13)
        Me.lblPostalCodeText.TabIndex = 2
        Me.lblPostalCodeText.Text = "Postal Code:"
        '
        'lblAddressText
        '
        Me.lblAddressText.AutoSize = True
        Me.lblAddressText.Location = New System.Drawing.Point(6, 46)
        Me.lblAddressText.Name = "lblAddressText"
        Me.lblAddressText.Size = New System.Drawing.Size(48, 13)
        Me.lblAddressText.TabIndex = 1
        Me.lblAddressText.Text = "Address:"
        '
        'lblNameText
        '
        Me.lblNameText.AutoSize = True
        Me.lblNameText.Location = New System.Drawing.Point(6, 16)
        Me.lblNameText.Name = "lblNameText"
        Me.lblNameText.Size = New System.Drawing.Size(38, 13)
        Me.lblNameText.TabIndex = 0
        Me.lblNameText.Text = "Name:"
        '
        'frmInquiry
        '
        Me.AcceptButton = Me.btnInquire
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnClear
        Me.ClientSize = New System.Drawing.Size(834, 337)
        Me.Controls.Add(Me.gpbContactInfo)
        Me.Controls.Add(Me.gpbCourseCodes)
        Me.Controls.Add(Me.btnInquire)
        Me.Controls.Add(Me.btnExit)
        Me.Controls.Add(Me.btnClear)
        Me.Controls.Add(Me.btnConnection)
        Me.Controls.Add(Me.lblMessage)
        Me.Controls.Add(Me.txtStudentNumber)
        Me.Controls.Add(Me.lblStudentNumber)
        Me.Controls.Add(Me.lblInquiry)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.Name = "frmInquiry"
        Me.Text = "EPI Inquiry"
        Me.gpbCourseCodes.ResumeLayout(False)
        Me.gpbCourseCodes.PerformLayout()
        Me.gpbContactInfo.ResumeLayout(False)
        Me.gpbContactInfo.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents lblInquiry As System.Windows.Forms.Label
    Friend WithEvents lblStudentNumber As System.Windows.Forms.Label
    Friend WithEvents txtStudentNumber As System.Windows.Forms.TextBox
    Friend WithEvents lblMessage As System.Windows.Forms.Label
    Friend WithEvents btnConnection As System.Windows.Forms.Button
    Friend WithEvents btnClear As System.Windows.Forms.Button
    Friend WithEvents btnExit As System.Windows.Forms.Button
    Friend WithEvents btnInquire As System.Windows.Forms.Button
    Friend WithEvents gpbCourseCodes As System.Windows.Forms.GroupBox
    Friend WithEvents lblCCFive As System.Windows.Forms.Label
    Friend WithEvents lblCCFour As System.Windows.Forms.Label
    Friend WithEvents lblCCThree As System.Windows.Forms.Label
    Friend WithEvents lblCCTwo As System.Windows.Forms.Label
    Friend WithEvents lblCCOne As System.Windows.Forms.Label
    Friend WithEvents lblNumberFive As System.Windows.Forms.Label
    Friend WithEvents lblNumberFour As System.Windows.Forms.Label
    Friend WithEvents lblNumberThree As System.Windows.Forms.Label
    Friend WithEvents lblNumberTwo As System.Windows.Forms.Label
    Friend WithEvents lblNumberOne As System.Windows.Forms.Label
    Friend WithEvents gpbContactInfo As System.Windows.Forms.GroupBox
    Friend WithEvents lblPhoneNumber As System.Windows.Forms.Label
    Friend WithEvents lblPostalCode As System.Windows.Forms.Label
    Friend WithEvents lblAddressThree As System.Windows.Forms.Label
    Friend WithEvents lblAddressTwo As System.Windows.Forms.Label
    Friend WithEvents lblAddressOne As System.Windows.Forms.Label
    Friend WithEvents lblStudentName As System.Windows.Forms.Label
    Friend WithEvents lblPhoneNumberText As System.Windows.Forms.Label
    Friend WithEvents lblPostalCodeText As System.Windows.Forms.Label
    Friend WithEvents lblAddressText As System.Windows.Forms.Label
    Friend WithEvents lblNameText As System.Windows.Forms.Label

End Class
