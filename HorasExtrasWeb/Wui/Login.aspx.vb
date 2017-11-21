Imports System.Configuration
Public Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        FormsAuthentication.SignOut()
        Session.Clear()
        Session.Abandon()
        Session.RemoveAll()
        Master.sesionIni = False
    End Sub

    Protected Sub Login_Click(sender As Object, e As EventArgs) Handles btnLogin.Click
        'Dim adAuth As LdapAuthentication = New LdapAuthentication("LDAP://")        
        Dim adAuth As New HorasExtras.Wsl.Seguridad()

        Try
            Dim Usuario As String = txtUsername.Text
            Dim CodEmp As String = String.Empty
            Dim NomEmp As String = String.Empty
            Dim resultado As Boolean = adAuth.ValidarCredenciales(Usuario, txtPassword.Text, txtDomain.Text, CodEmp, NomEmp)

            If resultado = True Then

                Dim groups As String = txtDomain.Text

                If Usuario Is Nothing Then
                    Usuario = txtUsername.Text
                End If

                'Create the ticket, and add the groups.
                Dim isCookiePersistent As Boolean = False
                Dim authTicket As FormsAuthenticationTicket = New FormsAuthenticationTicket(1,
                     txtUsername.Text, DateTime.Now, DateTime.Now.AddMinutes(10), isCookiePersistent, groups)

                'Encrypt the ticket.
                Dim encryptedTicket As String = FormsAuthentication.Encrypt(authTicket)

                'Create a cookie, and then add the encrypted ticket to the cookie as data.
                Dim authCookie As HttpCookie = New HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)

                If (isCookiePersistent = True) Then
                    authCookie.Expires = authTicket.Expiration
                End If
                'Add the cookie to the outgoing cookies collection.
                Response.Cookies.Add(authCookie)

                'Cookie personal
                Response.Cookies("Usuario")("TxtEmp") = Usuario
                Response.Cookies("Usuario")("CodEmp") = CodEmp
                Response.Cookies("Usuario")("NomEmp") = NomEmp
                Response.Cookies("Usuario").Expires = DateTime.Now.AddHours(1)

                'You can redirect now.
                Response.Redirect("~/Wui/Registro.aspx")
            Else
                errorLabel.Text = "La autenticación no tuvo éxito. Compruebe el nombre de usuario y la contraseña."
            End If

        Catch ex As Exception
            errorLabel.Text = "Error de autenticación. " & ex.Message
        End Try
    End Sub

End Class