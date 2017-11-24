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

        'Datos del empleado
        dsEmpleados = SQLConexionBD.RecuperarDatosEmpleado(user)
        If dsEmpleados Is Nothing Then
            Exit Sub
        End If
        dtEmpleados = dsEmpleados.Tables(0)
        DatosEmpleados(dtEmpleados)
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

End Class