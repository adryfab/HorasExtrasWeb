Public Class ImprimirAtrasos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Primero el procedimiento que llene el grid
        Llenar_Grid()

        'Ahora si, ¡a imprimir la página!
        With Response
            .Write("<script>")
            .Write("print()")
            .Write("</script>")
        End With
    End Sub

    Private Sub Llenar_Grid()
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim dsEmpleados As New DataSet
        Dim dtEmpleados As New DataTable
        Dim dsTablas As New DataSet
        Dim dtAtrasos As New DataTable
        Dim dtFechas As New DataTable
        Dim dtEmpleado As New DataTable
        Dim dtJefes As New DataTable

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

        'Totales del grid
        TotalesFooter()

        'Cabecera
        dsTablas = SQLConexionBD.RecuperarImprimir(user)
        dtFechas = dsTablas.Tables(0)
        dtEmpleado = dsTablas.Tables(1)
        dtJefes = dsTablas.Tables(4)
        Session("dtFechas") = dtFechas
        Session("dtEmpleado") = dtEmpleado
        Session("dtJefes") = dtJefes
        Cabecera()

    End Sub

    Private Sub BindDataGrid()
        gvAtrasos.DataSource = Session("dtAtrasos")
        gvAtrasos.DataBind()
    End Sub

    Private Sub TotalesFooter()
        Dim dtAtrasos As DataTable = Session("dtAtrasos")
        If dtAtrasos.Rows.Count > 0 Then
            Dim horAtr, minAtr As Integer
            For Each row As DataRow In dtAtrasos.Rows
                horAtr = horAtr + Convert.ToDateTime(row("Tiempo")).Hour
                minAtr = minAtr + Convert.ToDateTime(row("Tiempo")).Minute
            Next
            Dim ThorAtr As Integer = horAtr + Fix(minAtr / 60)
            Dim TminAtr As Integer = minAtr Mod 60
            gvAtrasos.FooterRow.Cells(3).Text = "Total"
            gvAtrasos.FooterRow.Cells(4).Text = String.Format("{0}:{1}", ThorAtr.ToString("0"), TminAtr.ToString("00"))
        End If
    End Sub

    Private Sub Cabecera()
        Dim dtFechas As DataTable = Session("dtFechas")
        Dim fechaInicial As Date = dtFechas.Rows(0).Item("FechaInicial").ToString
        Dim fechaFinal As Date = dtFechas.Rows(0).Item("FechaFinal").ToString
        lblPeriodo.Text = fechaInicial.ToString("dd-MM-yyyy") + " A " + fechaFinal.ToString("dd-MM-yyyy")

        Dim dtEmpleado As DataTable = Session("dtEmpleado")
        lblColaborador.Text = dtEmpleado.Rows(0).Item("COLABORADOR").ToString
        lblCargo.Text = dtEmpleado.Rows(0).Item("CARGO").ToString
        lblLocalidad.Text = dtEmpleado.Rows(0).Item("LOCALIDAD").ToString
        lblDepartamento.Text = dtEmpleado.Rows(0).Item("DPTO").ToString

        Dim dtJefes As DataTable = Session("dtJefes")
        lblSolicitante.Text = dtJefes.Rows(0).Item("COLABORADOR").ToString
        lblSupervisor.Text = dtJefes.Rows(0).Item("SUPERVISOR").ToString
        lblJefe.Text = dtJefes.Rows(0).Item("JEFE").ToString
    End Sub

    Protected Sub GridView_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            'Actualiza la aprobacion (SI/NO)
            Dim apr As String = DataBinder.Eval(e.Row.DataItem, "Aprobado").ToString()
            Dim lblApr As Label = TryCast(e.Row.Cells(14).Controls(1), Label)
            If apr = "1" Then
                lblApr.Text = "SI"
            Else
                lblApr.Text = "NO"
            End If
        End If
    End Sub

End Class