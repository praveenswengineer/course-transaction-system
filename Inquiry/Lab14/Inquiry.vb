Imports CclEPILib

Public Class frmInquiry

    Dim EPI As CclOEPI
    Dim terminal As CclOTerminal
    Dim session As CclOSession
    Dim screen As CclOScreen
    Dim map As CclOMap
    Dim field As CclOField
    Dim startupMessage As String

    Private Sub btnConnection_Click(sender As Object, e As EventArgs) Handles btnConnection.Click
        If btnConnection.Text = "Disconnect" Then
            screen.SetAID(CclAIDKeys.cclPF9)
            terminal.Send(session)
            terminal.Disconnect()
            field = Nothing
            screen = Nothing
            session = Nothing
            terminal = Nothing
            EPI = Nothing
            clear()
            lblMessage.Text = "Disconnected!"
            lblMessage.ForeColor = Color.Green
            btnConnection.Text = "Connect"
            btnExit.Enabled = True
            btnClear.Enabled = False
            btnInquire.Enabled = False
        Else
            EPI = New CclOEPI

            terminal = New CclOTerminal
            terminal.Connect("INFINITY", "", "")

            session = New CclOSession
            map = CreateObject("ccl.MAP")

            terminal.Start(session, "MV02", "")
            screen = terminal.Screen

            map = New CclOMap

            If (map.Validate(screen, IAEMAP)) Then
                field = map.FieldByName(IAEMAP_OUTMSG)
                startupMessage = field.Text
                lblMessage.Text = startupMessage
                lblMessage.ForeColor = Color.Green
            Else
                lblMessage.Text = "Unexpected screen data"
                lblMessage.ForeColor = Color.Red
                Exit Sub
            End If

            btnConnection.Text = "Disconnect"
            btnExit.Enabled = False
            btnClear.Enabled = True
            btnInquire.Enabled = True
            txtStudentNumber.Focus()
        End If

    End Sub

    Private Sub frmInquiry_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        EPI = New CclOEPI

        terminal = New CclOTerminal
        terminal.Connect("INFINITY", "", "")

        session = New CclOSession
        map = CreateObject("ccl.MAP")

        terminal.Start(session, "MV02", "")
        screen = terminal.Screen

        map = New CclOMap

        If (map.Validate(screen, IAEMAP)) Then
            field = map.FieldByName(IAEMAP_OUTMSG)
            startupMessage = field.Text
            lblMessage.Text = startupMessage
        Else
            lblMessage.Text = "Unexpected screen data"
            Exit Sub
        End If
        txtStudentNumber.Focus()
    End Sub

    Private Sub btnExit_Click(sender As Object, e As EventArgs) Handles btnExit.Click
        Me.Close()
    End Sub

    Private Sub btnInquire_Click(sender As Object, e As EventArgs) Handles btnInquire.Click

        Const VALID_LENGTH As Integer = 7
        Dim studentNumber As Integer

        If (txtStudentNumber.Text.Length < VALID_LENGTH) Then
            lblMessage.Text = "Student Number must be " & VALID_LENGTH.ToString() & " characters long."
            lblMessage.ForeColor = Color.Red
        ElseIf Not (Integer.TryParse(txtStudentNumber.Text, studentNumber)) Then
            lblMessage.Text = "Student Number must be a whole number."
            lblMessage.ForeColor = Color.Red
        Else
            field = map.FieldByName(IAEMAP_STUNUM)
            field.SetText(studentNumber.ToString())

            terminal.Start(session, "MV02", "")
            screen = terminal.Screen
            map = New CclOMap

            If (map.Validate(screen, IAEMAP)) Then
                field = map.FieldByName(IAEMAP_OUTMSG)
                lblMessage.Text = field.Text

                If (lblMessage.Text.Substring(0, 16) = "*ERROR AT INPUT*") Then
                    lblMessage.ForeColor = Color.Red
                Else

                    field = map.FieldByName(IAEMAP_ADDR01)
                    lblAddressOne.Text = field.Text
                    field = map.FieldByName(IAEMAP_ADDR02)
                    lblAddressTwo.Text = field.Text
                    field = map.FieldByName(IAEMAP_ADDR03)
                    lblAddressThree.Text = field.Text
                    field = map.FieldByName(IAEMAP_CCOD11)
                    lblCCOne.Text = field.Text
                    field = map.FieldByName(IAEMAP_CCOD12)
                    lblCCOne.Text &= field.Text
                    field = map.FieldByName(IAEMAP_CCOD21)
                    lblCCTwo.Text = field.Text
                    field = map.FieldByName(IAEMAP_CCOD22)
                    lblCCTwo.Text &= field.Text
                    field = map.FieldByName(IAEMAP_CCOD31)
                    lblCCThree.Text = field.Text
                    field = map.FieldByName(IAEMAP_CCOD32)
                    lblCCThree.Text &= field.Text
                    field = map.FieldByName(IAEMAP_CCOD41)
                    lblCCFour.Text = field.Text
                    field = map.FieldByName(IAEMAP_CCOD42)
                    lblCCFour.Text &= field.Text
                    field = map.FieldByName(IAEMAP_CCOD51)
                    lblCCFive.Text = field.Text
                    field = map.FieldByName(IAEMAP_CCOD52)
                    lblCCFive.Text &= field.Text
                    field = map.FieldByName(IAEMAP_STUNAM)
                    lblStudentName.Text = field.Text
                    field = map.FieldByName(IAEMAP_AREACO)
                    lblPhoneNumber.Text = "(" & field.Text & ") "
                    field = map.FieldByName(IAEMAP_EXCHCO)
                    lblPhoneNumber.Text &= field.Text & "-"
                    field = map.FieldByName(IAEMAP_PHONUM)
                    lblPhoneNumber.Text &= field.Text
                    field = map.FieldByName(IAEMAP_POSCO1)
                    lblPostalCode.Text = field.Text & " "
                    field = map.FieldByName(IAEMAP_POSCO2)
                    lblPostalCode.Text &= field.Text

                    gpbContactInfo.Visible = True
                    gpbCourseCodes.Visible = True
                    lblMessage.ForeColor = Color.Green
                End If
            End If
        End If
        txtStudentNumber.Focus()
        txtStudentNumber.SelectAll()
    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click

        lblMessage.ForeColor = Color.Green
        lblMessage.Text = startupMessage
        clear()
    End Sub

    Private Sub clear()
        lblMessage.Text = ""
        txtStudentNumber.Text = ""
        gpbContactInfo.Visible = False
        gpbCourseCodes.Visible = False
        txtStudentNumber.Focus()
    End Sub

    Private Sub txtStudentNumber_TextChanged(sender As Object, e As EventArgs) Handles txtStudentNumber.TextChanged
        lblMessage.ForeColor = Color.Green
        lblMessage.Text = startupMessage
        gpbContactInfo.Visible = False
        gpbCourseCodes.Visible = False

    End Sub
End Class
