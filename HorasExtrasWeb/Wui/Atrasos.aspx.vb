Public Class Atrasos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If (User.Identity.IsAuthenticated) Then
                Llenar_Grid()
            End If
        End If
    End Sub

    Private Sub Llenar_Grid()
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim dsEmpleados As New DataSet
        Dim dtEmpleados As New DataTable
        Dim dsTablas As New DataSet
        Dim dtAtrasos As New DataTable

        Dim user As String
        If (Request.Cookies("Usuario") IsNot Nothing) Then
            If (Request.Cookies("Usuario")("CodEmp") IsNot Nothing) Then
                user = Request.Cookies("Usuario")("CodEmp")
            Else
                Exit Sub
            End If
        Else
            Exit Sub
        End If

        dsTablas = SQLConexionBD.RecuperarAtrasos(user)
        If dsTablas Is Nothing Then
            Exit Sub
        End If
        dtAtrasos = dsTablas.Tables(0)
        Session("dtAtrasos") = dtAtrasos
        BindDataGrid()

        'Datos del empleado
        dsEmpleados = SQLConexionBD.RecuperarDatosEmpleado(user)
        If dsEmpleados Is Nothing Then
            Exit Sub
        End If
        dtEmpleados = dsEmpleados.Tables(0)
        DatosEmpleados(dtEmpleados)
    End Sub

    Private Sub BindDataGrid()
        gvAtrasos.DataSource = Session("dtAtrasos")
        gvAtrasos.DataBind()
    End Sub

    Private Sub DatosEmpleados(ByVal dtEmpleado As DataTable)
        Master.usuario = Context.User.Identity.Name
        Master.codigo = dtEmpleado.Rows(0)("CodigoEmp")
        Master.area = dtEmpleado.Rows(0)("Area")
        Master.areaId = dtEmpleado.Rows(0)("AreaId")
        Master.Dep = dtEmpleado.Rows(0)("Departamento")
        Master.DepId = dtEmpleado.Rows(0)("DepartamentoId")
        Master.Año = dtEmpleado.Rows(0)("Anio")
        Master.Periodo = dtEmpleado.Rows(0)("Periodo")
        Master.Inicio = dtEmpleado.Rows(0)("FechaInicial")
        Master.Fin = dtEmpleado.Rows(0)("FechaFinal")
        Master.Cargo = dtEmpleado.Rows(0)("Cargo")
        Master.CargoId = dtEmpleado.Rows(0)("CargoId")

        'Dim adAuth As LdapAuthentication = New LdapAuthentication("")
        Dim adAuth As New HorasExtras.Wsl.Seguridad()
        Master.procesar = adAuth.MenuProcesar(Master.areaId, Master.DepId, Master.CargoId)
        Master.aprobar = adAuth.MenuAprobar(Master.codigo)
        Master.sesionIni = True
    End Sub

    Protected Sub GridView_RowEditing(ByVal sender As Object, ByVal e As GridViewEditEventArgs)
        'Set the edit index.
        gvAtrasos.EditIndex = e.NewEditIndex

        'Bind data to the GridView control.
        BindDataGrid()
    End Sub

    Protected Sub GridView_RowCancelingEdit()
        'Reset the edit index.
        gvAtrasos.EditIndex = -1
        'Bind Data to the GridView control.
        BindDataGrid()
        'Llenar_Grid()
    End Sub

    Protected Sub GridView_RowUpdating(ByVal sender As Object, ByVal e As GridViewUpdateEventArgs)
        Try
            Dim dt As DataTable = CType(Session("dtAtrasos"), DataTable)
            Dim row As GridViewRow = gvAtrasos.Rows(e.RowIndex)
            Dim drow As DataRow = dt.Rows(row.DataItemIndex)

            If ValidarJustificacionGrid(row) = False Then Exit Sub

            'Actualizando el justificativo
            drow("Justificativo") = (CType(row.FindControl("Justificativo"), TextBox)).Text

            'Grabando el registro en la BD
            Dim AtrasosId As Integer = GrabarRegistros(drow)
            drow("AtrasosId") = AtrasosId

            'Reset the edit index.
            gvAtrasos.EditIndex = -1

            'Bind data to the GridView control.
            BindDataGrid()
            Llenar_Grid()
        Catch ex As Exception
            lblError.Text = ex.Message
            lblError.Visible = True
            divError.Visible = True
        End Try
    End Sub

    Private Function ValidarJustificacionGrid(ByVal row As GridViewRow) As Boolean
        Dim justificacion As String = (CType(row.FindControl("Justificativo"), TextBox)).Text
        Dim lblVal As Label = CType(row.FindControl("lblJustVal"), Label)
        If justificacion = Nothing Or justificacion = "" Then
            lblVal.Text = "FALTA!"
            lblVal.Visible = True
            Return False
        Else
            lblVal.Visible = False
            Return True
        End If
    End Function

    Private Function GrabarRegistros(ByVal rows As DataRow) As Integer
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim AtrasosId As Integer
        Dim infoXlm As String = infoXML(rows)
        AtrasosId = SQLConexionBD.GrabarAtrasos(Master.codigo, infoXlm)
        Return AtrasosId
    End Function

    Public Function infoXML(ByVal row As DataRow) As String
        Dim cadenaXML As String = String.Empty

        cadenaXML &= "<ATRASO "
        cadenaXML &= "CODEMP=""" & Master.codigo & """ "
        cadenaXML &= "ANIOPE=""" & Master.Año & """ "
        cadenaXML &= "PERIOD=""" & Master.Periodo & """ "
        Dim fecha As Date = row.Item("Fecha")
        cadenaXML &= "FECHAM=""" & fecha.ToString("yyyy-MM-dd") & """ "
        Dim ingreso As DateTime
        If Not IsDBNull(row.Item("Ingreso")) Then
            ingreso = row.Item("Ingreso")
        Else
            ingreso = fecha
        End If
        cadenaXML &= "INGRES=""" & ingreso.ToString("yyyy-MM-dd HH:mm") & """ "
        Dim tiempo As DateTime = row.Item("Tiempo")
        cadenaXML &= "TIEMPO=""" & tiempo.ToString("yyyy-MM-dd HH:mm") & """ "
        cadenaXML &= "CODNOV=""" & row.Item("CodNov").ToString & """ "
        cadenaXML &= "DETNOV=""" & row.Item("Tipo").ToString & """ "
        cadenaXML &= "JUSTIF=""" & row.Item("Justificativo").ToString & """ "
        cadenaXML &= "ACTIVO=""" & row.Item("Activo") & """ "
        cadenaXML &= "BIOMET=""" & row.Item("Biometrico") & """ "
        cadenaXML &= "ATRAID=""" & row.Item("AtrasosId").ToString & """ "
        cadenaXML &= " /> "

        Return cadenaXML
    End Function

End Class
