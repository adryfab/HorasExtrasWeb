Public Class ImprimirRegistro
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Primero el procedimiento que llene el grid
        LlenarGrid()

        'Ahora si, ¡a imprimir la página!
        With Response
            .Write("<script>")
            .Write("print()")
            .Write("</script>")
        End With

    End Sub

    Private Sub LlenarGrid()
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim dsTablas As New DataSet
        Dim dtFechas As New DataTable
        Dim dtEmpleado As New DataTable
        Dim dtSuple50 As New DataTable
        Dim dtExtra100 As New DataTable
        Dim dtJefes As New DataTable
        Dim dtAprobacion As New DataTable

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

        dsTablas = SQLConexionBD.RecuperarImprimir(user)
        dtFechas = dsTablas.Tables(0)
        dtEmpleado = dsTablas.Tables(1)
        dtSuple50 = dsTablas.Tables(2)
        dtExtra100 = dsTablas.Tables(3)
        dtJefes = dsTablas.Tables(4)
        dtAprobacion = dsTablas.Tables(5)

        Session("dtFechas") = dtFechas
        Session("dtEmpleado") = dtEmpleado
        Session("dtSuple50") = dtSuple50
        Session("dtExtra100") = dtExtra100
        Session("dtJefes") = dtJefes
        Session("dtAprobacion") = dtAprobacion

        BindDataGrid()
        Cabecera()
        Totales()
    End Sub

    Private Sub BindDataGrid()
        gvBiometrico50.DataSource = Session("dtSuple50")
        gvBiometrico50.DataBind()
        gvBiometrico100.DataSource = Session("dtExtra100")
        gvBiometrico100.DataBind()
    End Sub

    Private Sub CambiarEstilo()
        For Each row As DataRow In gvBiometrico50.Rows
            If row.Item("Biometrico") = 0 Then
                'gvBiometrico50.Rows(row).Cells(c).Font.Bold = True 'o False
            End If
        Next
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

        Dim dtAprobacion As DataTable = Session("dtAprobacion")
        lblAtrasos.Text = dtAprobacion.Rows(0).Item("Atrasos").ToString
    End Sub

    Private Sub Totales()
        Session("TotHor050") = "0"
        Session("TotMin050") = "0"
        Session("TotHor100") = "0"
        Session("TotMin100") = "0"

        Dim dtSuple50 As DataTable = Session("dtSuple50")
        '¿Existen registros del 50%?
        If dtSuple50.Rows.Count > 0 Then
            Dim horLab, horPer, horRec, hor050 As Integer
            Dim minLab, minPer, minRec, min050 As Integer
            For Each row As DataRow In dtSuple50.Rows
                horLab = horLab + Convert.ToDateTime(row("Laborado")).Hour
                minLab = minLab + Convert.ToDateTime(row("Laborado")).Minute
                horPer = horPer + Convert.ToDateTime(row("HorasPermiso")).Hour
                minPer = minPer + Convert.ToDateTime(row("HorasPermiso")).Minute
                horRec = horRec + Convert.ToDateTime(row("HorasRecuperar")).Hour
                minRec = minRec + Convert.ToDateTime(row("HorasRecuperar")).Minute
                hor050 = hor050 + Convert.ToDateTime(row("Horas50")).Hour
                min050 = min050 + Convert.ToDateTime(row("Horas50")).Minute
            Next

            gvBiometrico50.FooterRow.Cells(2).ColumnSpan = 3
            gvBiometrico50.FooterRow.Cells(2).HorizontalAlign = HorizontalAlign.Right
            gvBiometrico50.FooterRow.Cells(2).Text = "Total Permiso"
            Dim fhorper As Integer = horPer + Fix(minPer / 60)
            Dim fminper As Integer = minPer Mod 60
            gvBiometrico50.FooterRow.Cells(3).Text = String.Format("{0}:{1}", fhorper.ToString("0"), fminper.ToString("00"))
            Dim fHor050 As Integer = hor050 + Fix(min050 / 60)
            Dim fMin050 As Integer = min050 Mod 60
            gvBiometrico50.FooterRow.Cells(4).Text = String.Format("{0}:{1}", fHor050.ToString("0"), fMin050.ToString("00"))
            gvBiometrico50.FooterRow.Cells(5).Visible = False
            gvBiometrico50.FooterRow.Cells(6).Visible = False

            SumTotal050(min050, minPer, hor050, horPer)

            lblSuplementario.Visible = True
        Else
            lblSuplementario.Visible = False
        End If

        Dim dtExtra100 As DataTable = Session("dtExtra100")
        '¿Existen registros del 100%?
        If dtExtra100.Rows.Count > 0 Then
            Dim horLab, horPer, horRec, hor100 As Integer
            Dim minLab, minPer, minRec, min100 As Integer
            For Each row As DataRow In dtExtra100.Rows
                horLab = horLab + Convert.ToDateTime(row("Laborado")).Hour
                minLab = minLab + Convert.ToDateTime(row("Laborado")).Minute
                horPer = horPer + Convert.ToDateTime(row("HorasPermiso")).Hour
                minPer = minPer + Convert.ToDateTime(row("HorasPermiso")).Minute
                horRec = horRec + Convert.ToDateTime(row("HorasRecuperar")).Hour
                minRec = minRec + Convert.ToDateTime(row("HorasRecuperar")).Minute
                hor100 = hor100 + Convert.ToDateTime(row("Horas100")).Hour
                min100 = min100 + Convert.ToDateTime(row("Horas100")).Minute
            Next

            gvBiometrico100.FooterRow.Cells(2).ColumnSpan = 3
            gvBiometrico100.FooterRow.Cells(2).HorizontalAlign = HorizontalAlign.Right
            gvBiometrico100.FooterRow.Cells(2).Text = "Total Recuperar"
            Dim fHorRec As Integer = horRec + Fix(minRec / 60)
            Dim fMinRec As Integer = minRec Mod 60
            gvBiometrico100.FooterRow.Cells(3).Text = String.Format("{0}:{1}", fHorRec.ToString("0"), fMinRec.ToString("00"))
            Dim fHor100 As Integer = hor100 + Fix(min100 / 60)
            Dim fMin100 As Integer = min100 Mod 60
            gvBiometrico100.FooterRow.Cells(4).Text = String.Format("{0}:{1}", fHor100.ToString("0"), fMin100.ToString("00"))
            gvBiometrico100.FooterRow.Cells(5).Visible = False
            gvBiometrico100.FooterRow.Cells(6).Visible = False

            SumTotal100(min100, minRec, hor100, horRec)

            lblExtra.Visible = True
        Else
            lblExtra.Visible = False
        End If

        CalculoAtrasos()
    End Sub

    Private Sub SumTotal050(ByVal min050 As Integer, ByVal minPer As Integer, ByVal hor050 As Integer, ByVal horPer As Integer)
        Dim horTot050, minTot050 As Integer

        If min050 >= minPer Then
            horTot050 = hor050 - horPer
            minTot050 = min050 - minPer
        Else
            horTot050 = hor050 - horPer - 1
            minTot050 = (minPer - (min050 + 60)) * (-1)
        End If

        Dim ftothor50 As Integer = horTot050 + Fix(minTot050 / 60)
        Dim ftotmin50 As Integer = minTot050 Mod 60
        Dim tothor50 As String = ftothor50.ToString("0")
        Dim totmin50 As String = ftotmin50.ToString("00")

        Session("TotHor050") = tothor50
        Session("TotMin050") = totmin50
    End Sub

    Private Sub SumTotal100(ByVal min100 As Integer, ByVal minRec As Integer, ByVal hor100 As Integer, ByVal horRec As Integer)
        Dim minTot100, horTot100 As Integer

        If min100 >= minRec Then
            horTot100 = hor100 - horRec
            minTot100 = min100 - minRec
        Else
            horTot100 = hor100 - horRec - 1
            minTot100 = (minRec - (min100 + 60)) * (-1)
        End If

        Dim ftothor100 As Integer = horTot100 + Fix(minTot100 / 60)
        Dim ftotmin100 As Integer = minTot100 Mod 60
        Dim tothor100 As String = ftothor100.ToString("0")
        Dim totmin100 As String = ftotmin100.ToString("00")

        Session("TotHor100") = tothor100
        Session("TotMin100") = totmin100
    End Sub

    Private Sub CalculoAtrasos()
        'Obteniendo totales 50%
        Dim tothor50 As String = Session("TotHor050")
        Dim totmin50 As String = Session("TotMin050")

        'Obteniendo totales 100%
        Dim tothor100 As String = Session("TotHor100")
        Dim totmin100 As String = Session("TotMin100")

        'Unificando horas y minutos 50% 
        Dim strTotHoras50 As String = tothor50 + ":" + totmin50

        'Convirtiendo en formato time 50%
        Dim timeTotal50 As DateTime = Convert.ToDateTime(strTotHoras50)

        'Obteniendo el atraso
        Dim atraso As DateTime = Convert.ToDateTime(lblAtrasos.Text)

        'Restando el 50% del atraso        
        Dim Resta50 As TimeSpan = timeTotal50.Subtract(atraso)

        'Se verifica si el atraso es superior al 50%
        If Resta50.Ticks < 0 Then 'Aun falta descontar atrasos
            tothor50 = "0"
            totmin50 = "0"

            'Se obtiene el resultado de la resta anterior
            Dim newAtraso As String = Math.Abs(Resta50.Hours).ToString("0") + ":" + Math.Abs(Resta50.Minutes).ToString("00")
            atraso = Convert.ToDateTime(newAtraso)

            'Unificando horas y minutos 100%
            Dim strTotHoras100 As String = tothor100 + ":" + totmin100

            'Convirtiendo en formato time 100%
            Dim timeTotal100 As DateTime = Convert.ToDateTime(strTotHoras100)

            'Restando el 100% del resultado del atraso
            Dim Resta100 As TimeSpan = timeTotal100.Subtract(atraso)

            'Se verifica si aun falta descontar
            If Resta100.Ticks < 0 Then 'Aun falta descontar atrasos
                tothor100 = "0"
                totmin100 = "0"

                'El negativo sobrante se incluye en el 50%
                tothor50 = "-" + Math.Abs(Resta100.Hours).ToString("0")
                totmin50 = Math.Abs(Resta100.Minutes).ToString("00")
            Else 'Se descontó todo el atraso y aún hay 100% a pagar
                tothor100 = Resta100.Hours
                totmin100 = Resta100.Minutes
            End If

        Else 'Se descontó todo el atraso y aún hay 50% a pagar
            tothor50 = Resta50.Hours
            totmin50 = Resta50.Minutes
        End If

        'Se obtiene el 50%
        Dim dtSuple50 As DataTable = Session("dtSuple50")
        '¿Existen registros del 50%?
        If dtSuple50.Rows.Count > 0 Then
            Dim row As New GridViewRow(0, 0, DataControlRowType.Footer, DataControlRowState.Normal)
            Dim cel0, cel050 As New TableCell()

            cel0.Text = "Total de Horas al 50% al mes a pagar"
            cel0.ColumnSpan = 6
            cel0.HorizontalAlign = HorizontalAlign.Right
            row.Cells.Add(cel0)

            cel050.Text = String.Format("{0}:{1}", tothor50, totmin50)
            row.Cells.Add(cel050) 'Total

            gvBiometrico50.Controls(0).Controls.Add(row)
        End If

        'Se obtiene el 100%
        Dim dtExtra100 As DataTable = Session("dtExtra100")
        '¿Existen registros del 100%?
        If dtExtra100.Rows.Count > 0 Then
            Dim row As New GridViewRow(0, 0, DataControlRowType.Footer, DataControlRowState.Normal)
            Dim cel0, cel100 As New TableCell()

            cel0.Text = "Total de Horas al 100% al mes a pagar"
            cel0.ColumnSpan = 6
            cel0.HorizontalAlign = HorizontalAlign.Right
            row.Cells.Add(cel0)

            cel100.Text = String.Format("{0}:{1}", tothor100, totmin100)
            row.Cells.Add(cel100) 'Total

            gvBiometrico100.Controls(0).Controls.Add(row)
        End If

    End Sub

    Protected Sub GridView_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            'Cambia de fuente en la fila si no es del biometrico (ingreso manual)
            Dim desc As String = DataBinder.Eval(e.Row.DataItem, "Biometrico").ToString()
            If desc = "0" Then
                e.Row.Font.Italic = False
                e.Row.Font.Name = "Impact"
                'Si es el Justificativo, no se cambia la fuente
                Dim lblJus As Label = TryCast(e.Row.Cells(7).Controls(1), Label)
                lblJus.Font.Name = "Courier New"
            Else
                e.Row.Font.Italic = False
                e.Row.Font.Name = "Courier New"
            End If

            'Actualiza la aprobacion (SI/NO)
            Dim apr As String = DataBinder.Eval(e.Row.DataItem, "Aprobado").ToString()
            Dim lblApr As Label = TryCast(e.Row.Cells(10).Controls(1), Label)
            If apr = "True" Then
                lblApr.Text = "SI"
            Else
                lblApr.Text = "NO"
            End If
        End If
    End Sub

End Class