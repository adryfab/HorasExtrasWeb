﻿Public Class Aprobacion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If (User.Identity.IsAuthenticated) Then
                Llenar_Grid()
            End If
        End If
    End Sub

#Region "Manejo de Datos"

    Private Sub Llenar_Grid()
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim dtEmpleado As New DataTable
        Dim dsTablas As New DataSet
        Dim dtAprobaciones As New DataTable
        Dim dsEmpleados As New DataSet

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
        dtEmpleado = dsEmpleados.Tables(0)
        DatosEmpleado(dtEmpleado)

        'Aprobaciones de Horas Extras
        dsTablas = SQLConexionBD.RecuperarAprobaciones(user)
        If dsTablas Is Nothing Or dsTablas.Tables.Count = 0 Then
            Exit Sub
        End If
        dtAprobaciones = dsTablas.Tables(0)
        Session("dtAprobaciones") = dtAprobaciones
        BindDataGrid()
    End Sub

    Private Sub DatosEmpleado(ByVal dtEmpleado As DataTable)
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

        Dim adAuth As New HorasExtras.Wsl.Seguridad()
        Master.procesar = adAuth.MenuProcesar(Master.areaId, Master.DepId, Master.CargoId)
        Master.aprobar = adAuth.MenuAprobar(Master.codigo)
        Master.sesionIni = True
    End Sub

    Private Sub BindDataGrid()
        gvAprobar.DataSource = Session("dtAprobaciones")
        gvAprobar.DataBind()
        gvAprobarAtrasos.DataSource = Session("dtAprobaciones")
        gvAprobarAtrasos.DataBind()
    End Sub

    Protected Sub OnConfirm(ByVal sender As Object, ByVal e As EventArgs)
        Dim confirmValue As String = Request.Form("confirm_value")
        If confirmValue = "Si" Then
            'Get the button that raised the event
            Dim btn As ImageButton = DirectCast(sender, ImageButton)
            'Get the row that contains this button
            Dim row As GridViewRow = DirectCast(btn.NamingContainer, GridViewRow)

            Dim dt As DataTable = CType(Session("dtAprobaciones"), DataTable)
            Dim rows As DataRow = dt.Rows(row.DataItemIndex)

            If btn.ID = "ButtonAprobar" Then
                'Validar Si están todos los registros justificados
                Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
                If SQLConexionBD.ValidarJustificacion(rows.Item("NOMINA_ID")) = False Then
                    'Mostrar mensaje
                    id01.Visible = True
                    id01.Style.Item("display") = "block"
                    Exit Sub
                Else
                    'Ocultar mensaje
                    id01.Visible = False
                    id01.Style.Item("display") = "none"
                End If

                If rows.Item("SUPERVISOR") = "True" Then
                    rows.Item("UsuarioSuper") = Master.usuario
                    rows.Item("FechaSuper") = DateTime.Now.ToShortDateString
                Else
                    'rows.Item("UsuarioJefe") = lblUsuario.Text
                    rows.Item("UsuarioJefe") = Master.usuario
                    rows.Item("FechaJefe") = DateTime.Now.ToShortDateString
                End If
            ElseIf btn.ID = "ButtonRechazar" Then
                'Ocultar mensaje
                id01.Visible = False
                id01.Style.Item("display") = "none"

                If rows.Item("SUPERVISOR") = "True" Then
                    rows.Item("UsuarioSuper") = ""
                    rows.Item("FechaSuper") = System.DBNull.Value
                Else
                    rows.Item("UsuarioJefe") = ""
                    rows.Item("FechaJefe") = System.DBNull.Value
                End If
            End If

            If GrabarRegistros(rows) = 1 Then 'OK
                Llenar_Grid()
            End If
        End If
    End Sub

    Protected Sub OnConfirmAtraso(ByVal sender As Object, ByVal e As EventArgs)
        Dim confirmValue As String = Request.Form("confirm_value")
        If confirmValue = "Si" Then
            'Get the button that raised the event
            Dim btn As ImageButton = DirectCast(sender, ImageButton)
            'Get the row that contains this button
            Dim row As GridViewRow = DirectCast(btn.NamingContainer, GridViewRow)

            Dim dt As DataTable = CType(Session("dtAtrasos"), DataTable)
            Dim rows As DataRow = dt.Rows(row.DataItemIndex)

            If rows.Item("Justificativo") = "" Then
                'Mostrar mensaje
                id01.Visible = True
                id01.Style.Item("display") = "block"
                Exit Sub
            Else
                'Ocultar mensaje
                id01.Visible = False
                id01.Style.Item("display") = "none"
            End If

            If btn.ID = "ButtonAprobar" Then
                rows.Item("Aprobado") = True
            ElseIf btn.ID = "ButtonRechazar" Then
                rows.Item("Aprobado") = False
            End If

            If GrabarAtrasos(rows) = 1 Then 'OK
                Llenar_Grid_Atrasos(rows.Item("CodigoEmp"))
                Llenar_Grid()
            End If
        End If
    End Sub

    Protected Sub OnConfirmDetalle(ByVal sender As Object, ByVal e As EventArgs)
        Dim confirmValue As String = Request.Form("confirm_value")
        If confirmValue = "Si" Then
            'Get the button that raised the event
            Dim btn As ImageButton = DirectCast(sender, ImageButton)
            'Get the row that contains this button
            Dim row As GridViewRow = DirectCast(btn.NamingContainer, GridViewRow)

            Dim dt As DataTable = CType(Session("dtBiometrico"), DataTable)
            Dim rows As DataRow = dt.Rows(row.DataItemIndex)

            If rows.Item("Justificativo") = "" Then
                'Mostrar mensaje
                id01.Visible = True
                id01.Style.Item("display") = "block"
                Exit Sub
            Else
                'Ocultar mensaje
                id01.Visible = False
                id01.Style.Item("display") = "none"
            End If

            If btn.ID = "ButtonAprobar" Then
                rows.Item("Aprobado") = True
            ElseIf btn.ID = "ButtonRechazar" Then
                rows.Item("Aprobado") = False
            End If

            If GrabarDetalles(rows) = 1 Then 'OK
                Llenar_Grid_Detalle(rows.Item("CodigoEmp"))
            End If

        End If
    End Sub

    Private Function GrabarRegistros(ByVal rows As DataRow) As Integer
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim Resultados As Integer
        Dim infoXlm As String = infoXML(rows)
        Resultados = SQLConexionBD.GrabarAprobacion(infoXlm)
        Return Resultados
    End Function

    Private Function GrabarAtrasos(ByVal rows As DataRow) As Integer
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim AtrasosId As Integer
        Dim infoXlm As String = infoAtrasosXML(rows)
        AtrasosId = SQLConexionBD.GrabarAtrasos(Master.codigo, infoXlm)
        Return AtrasosId
    End Function

    Private Function GrabarDetalles(ByVal rows As DataRow) As Integer
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim HorasExtrasId As Integer
        Dim infoXlm As String = infoDetalleXML(rows)
        HorasExtrasId = SQLConexionBD.GrabarRegisto(Context.User.Identity.Name, infoXlm)
        Return HorasExtrasId
    End Function

    Public Function infoXML(ByVal row As DataRow) As String
        Dim cadenaXML As String = String.Empty

        cadenaXML &= "<APROBA "
        cadenaXML &= "CODEMP=""" & row.Item("NOMINA_ID").ToString & """ "
        cadenaXML &= "ANIOPE=""" & Master.Año & """ "
        cadenaXML &= "PERIOD=""" & Master.Periodo & """ "
        cadenaXML &= "HORA50=""" & row.Item("SUPLEMENTARIAS").ToString & """ "
        cadenaXML &= "HOR100=""" & row.Item("EXTRAORDINARIAS").ToString & """ "
        cadenaXML &= "SUPERV=""" & row.Item("SUPERVISOR").ToString & """ "
        cadenaXML &= "USUARI=""" & Master.usuario & """ "
        cadenaXML &= "USUSUP=""" & row.Item("UsuarioSuper").ToString & """ "
        If row.Item("FechaSuper") IsNot System.DBNull.Value Then
            Dim fechaSuper As Date = row.Item("FechaSuper")
            cadenaXML &= "FECSUP=""" & fechaSuper.ToString("yyyy-MM-dd") & """ "
        Else
            cadenaXML &= "FECSUP=""" & row.Item("FechaSuper").ToString & """ "
        End If
        cadenaXML &= "USUJEF=""" & row.Item("UsuarioJefe").ToString & """ "
        If row.Item("FechaJefe") IsNot System.DBNull.Value Then
            Dim fechaJefe As Date = row.Item("FechaJefe")
            cadenaXML &= "FECJEF=""" & fechaJefe.ToString("yyyy-MM-dd") & """ "
        Else
            cadenaXML &= "FECJEF=""" & row.Item("FechaJefe").ToString & """ "
        End If
        cadenaXML &= " /> "

        Return cadenaXML
    End Function

    Public Function infoAtrasosXML(ByVal row As DataRow) As String
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
        cadenaXML &= "APROBA=""" & row.Item("Aprobado") & """ "
        cadenaXML &= " /> "

        Return cadenaXML
    End Function

    Public Function infoDetalleXML(ByVal row As DataRow) As String
        Dim cadenaXML As String = String.Empty

        cadenaXML &= "<HOREXT "
        cadenaXML &= "CODEMP=""" & Master.codigo & """ "
        Dim fecha As Date = row.Item("Fecha")
        cadenaXML &= "FECHAM=""" & fecha.ToString("yyyy-MM-dd") & """ "
        Dim ingreso As DateTime = row.Item("Ingreso")
        cadenaXML &= "INGRES=""" & ingreso.ToString("HH:mm") & """ "
        Dim salida As DateTime = row.Item("Salida")
        cadenaXML &= "SALIDA=""" & salida.ToString("HH:mm") & """ "
        Dim laborado As DateTime = row.Item("Laborado")
        cadenaXML &= "LABORA=""" & laborado.ToString("HH:mm") & """ "
        Dim atrasado As DateTime = row.Item("Atrasado")
        cadenaXML &= "ATRASA=""" & atrasado.ToString("HH:mm") & """ "
        Dim anticipado As DateTime = row.Item("Anticipado")
        cadenaXML &= "ANTICI=""" & anticipado.ToString("HH:mm") & """ "
        Dim hora0 As DateTime = row.Item("Horas0")
        cadenaXML &= "HORA00=""" & hora0.ToString("HH:mm") & """ "
        Dim hora50 As DateTime = row.Item("Horas50")
        cadenaXML &= "HORA50=""" & hora50.ToString("HH:mm") & """ "
        Dim hora100 As DateTime = row.Item("Horas100")
        cadenaXML &= "HOR100=""" & hora100.ToString("HH:mm") & """ "
        Dim horaPermiso As DateTime = row.Item("HorasPermiso")
        cadenaXML &= "HORPER=""" & horaPermiso.ToString("HH:mm") & """ "
        Dim horaRecuperar As DateTime = row.Item("HorasRecuperar")
        cadenaXML &= "HORREC=""" & horaRecuperar.ToString("HH:mm") & """ "
        cadenaXML &= "JUSTIF=""" & row.Item("Justificativo").ToString & """ "
        cadenaXML &= "ANIOPE=""" & Master.Año & """ "
        cadenaXML &= "PERIOD=""" & Master.Periodo & """ "
        cadenaXML &= "HOREXT=""" & row.Item("HorasExtrasId").ToString & """ "
        cadenaXML &= "ACTIVO=""" & row.Item("Activo") & """ "
        cadenaXML &= "BIOMET=""" & row.Item("Biometrico") & """ "
        cadenaXML &= "APROBA=""" & row.Item("Aprobado") & """ "
        cadenaXML &= " /> "

        Return cadenaXML
    End Function

    Private Sub Llenar_Grid_Detalle(ByVal user As String)
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim dtBiometrico As New DataTable
        Dim dsTablas As New DataSet

        dsTablas = SQLConexionBD.RecuperarDatosBiometricoPorUsuario(user)
        dtBiometrico = dsTablas.Tables(0)
        Session("dtBiometrico") = dtBiometrico
        BindDataGridDetalle()
    End Sub

    Private Sub Llenar_Grid_Atrasos(ByVal user As String)
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim dsTablas As New DataSet
        Dim dtAtrasos As New DataTable

        dsTablas = SQLConexionBD.RecuperarAtrasos(user)
        If dsTablas Is Nothing Then
            Exit Sub
        End If
        dtAtrasos = dsTablas.Tables(0)
        Session("dtAtrasos") = dtAtrasos
        BindDataGridAtrasos()
    End Sub

    Private Sub BindDataGridDetalle()
        gvBiometrico.DataSource = Session("dtBiometrico")
        gvBiometrico.DataBind()
    End Sub

    Private Sub BindDataGridAtrasos()
        gvAtrasos.DataSource = Session("dtAtrasos")
        gvAtrasos.DataBind()
    End Sub

    Private Sub CambiarPlusMinus(ByVal index As Integer, ByVal gv As GridView, ByVal tr As HtmlTableRow)
        id01.Visible = False
        id01.Style.Item("display") = "none"

        Dim imgButon As ImageButton = gv.Rows(index).FindControl("ButtonMas")
        Dim id As Label = gv.Rows(index).FindControl("NOMINA_ID")

        'Cambiando todos los iconos a plus
        For Each row As GridViewRow In gv.Rows
            Dim img As ImageButton = row.FindControl("ButtonMas")
            Dim lab As Label = row.FindControl("NOMINA_ID")
            If id.Text = lab.Text Then Continue For 'Siguiente registro
            img.ImageUrl = "../icons/plus.gif"
        Next

        If imgButon.ImageUrl = "../icons/plus.gif" Then
            imgButon.ImageUrl = "../icons/minus.gif"
            tr.Visible = True
        Else
            imgButon.ImageUrl = "../icons/plus.gif"
            tr.Visible = False
        End If
    End Sub

    Protected Shared Function FindControlRecursive(root As Control, ctrlID As [String]) As Control
        If root.ID = ctrlID Then
            Return root
        End If
        For Each ctrl As Control In root.Controls
            Dim foundControl As Control = FindControlRecursive(ctrl, ctrlID)
            If Not (foundControl Is Nothing) Then
                Return foundControl
            End If
        Next
        Return Nothing
    End Function

    Private Function EliminarRegistros(ByVal rows As DataRow) As Integer
        Dim SQLConexionBD As New HorasExtras.Wsl.Seguridad()
        Dim Resultados As Integer
        Dim infoXlm As String = infoDetalleXML(rows)
        Resultados = SQLConexionBD.EliminarRegistro(rows.Item("CodigoEmp"), infoXlm)
        Return Resultados
    End Function

#End Region

#Region "Eventos"

    Protected Sub GridView_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "PlusMas" Then
            Dim rowIndex As Integer
            rowIndex = Integer.Parse(e.CommandArgument.ToString)
            Dim gvRow As GridViewRow = gvAprobar.Rows(rowIndex)
            Dim NOMINA_ID As Label = CType(gvRow.FindControl("NOMINA_ID"), Label)
            Llenar_Grid_Detalle(NOMINA_ID.Text)
            CambiarPlusMinus(rowIndex, gvAprobar, trmostrar)
        End If
    End Sub

    Protected Sub GridViewAprAtr_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "PlusMas" Then
            Dim rowIndex As Integer
            rowIndex = Integer.Parse(e.CommandArgument.ToString)
            Dim gvRow As GridViewRow = gvAprobar.Rows(rowIndex)
            Dim NOMINA_ID As Label = CType(gvRow.FindControl("NOMINA_ID"), Label)
            Llenar_Grid_Atrasos(NOMINA_ID.Text)
            CambiarPlusMinus(rowIndex, gvAprobarAtrasos, trMostrarAtrasos)
        End If
    End Sub

    Protected Sub GridView_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim imgAprobar As ImageButton = TryCast(e.Row.Cells(11).Controls(1), ImageButton)
            Dim imgRechazar As ImageButton = TryCast(e.Row.Cells(11).Controls(3), ImageButton)
            Dim lblAprobado As Label = TryCast(e.Row.Cells(12).Controls(1), Label)
            If DirectCast(e.Row.Cells(10).Controls(1), System.Web.UI.WebControls.Label).Text = "True" Then 'SUPERVISOR
                If DirectCast(e.Row.Cells(6).Controls(1), System.Web.UI.WebControls.Label).Text = "" Then 'UsuarioSuper
                    imgAprobar.Visible = True
                    imgRechazar.Visible = False
                    lblAprobado.Visible = True
                    lblAprobado.Text = "Por aprobar"
                Else
                    imgAprobar.Visible = False
                    imgRechazar.Visible = True
                    lblAprobado.Visible = True
                    lblAprobado.Text = "Aprobado"
                End If
            End If
        End If
    End Sub

    Protected Sub GridViewAtrasos_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim imgAprobar As ImageButton = TryCast(e.Row.Cells(14).Controls(1), ImageButton)
            Dim imgRechazar As ImageButton = TryCast(e.Row.Cells(14).Controls(3), ImageButton)
            Dim lblAprobado As Label = TryCast(e.Row.Cells(15).Controls(1), Label)
            If DirectCast(e.Row.Cells(13).Controls(1), System.Web.UI.WebControls.Label).Text = "1" Then 'Aprobado
                imgAprobar.Visible = False
                imgRechazar.Visible = True
                lblAprobado.Visible = True
                lblAprobado.Text = "Aprobado"
            Else
                imgAprobar.Visible = True
                imgRechazar.Visible = False
                lblAprobado.Visible = True
                lblAprobado.Text = "Por Aprobar"
            End If
        End If
    End Sub

    Protected Sub GridViewDetalle_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim imgAprobar As ImageButton = TryCast(e.Row.Cells(20).Controls(1), ImageButton)
            Dim imgRechazar As ImageButton = TryCast(e.Row.Cells(20).Controls(3), ImageButton)
            Dim lblAprobado As Label = TryCast(e.Row.Cells(21).Controls(1), Label)
            If DirectCast(e.Row.Cells(22).Controls(1), System.Web.UI.WebControls.Label).Text = "True" Then 'Aprobado
                imgAprobar.Visible = False
                imgRechazar.Visible = True
                lblAprobado.Visible = True
                lblAprobado.Text = "Aprobado"
            Else
                imgAprobar.Visible = True
                imgRechazar.Visible = False
                lblAprobado.Visible = True
                lblAprobado.Text = "Por Aprobar"
            End If
        End If
    End Sub

    Protected Sub GridViewAprAtr_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            'No se programa nada porque la aprobación ya no está en la cabecera sino en el detalle
        End If
    End Sub

    Protected Sub GridView_RowDeleting(ByVal sender As Object, ByVal e As GridViewDeleteEventArgs)
        Dim DTable As New DataTable("dtBiometrico")
        DTable = Session("dtBiometrico")
        DTable.Rows(e.RowIndex)("Activo") = False
        Dim rows As DataRow = DTable.Rows(e.RowIndex)
        Dim codEmp As String = rows.Item("CodigoEmp")
        Dim horasExtrasId As Integer = DTable.Rows(e.RowIndex)("HorasExtrasId")
        Dim Resultado As Integer
        If horasExtrasId = 0 Then 'Es nuevo
            Resultado = GrabarRegistros(rows)
        Else
            Resultado = EliminarRegistros(rows)
        End If
        DTable.Rows(e.RowIndex).Delete()
        Session("dtBiometrico") = DTable
        Llenar_Grid_Detalle(codEmp)
        Llenar_Grid()
    End Sub

#End Region

End Class