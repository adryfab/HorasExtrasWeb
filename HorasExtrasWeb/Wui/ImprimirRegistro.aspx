<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ImprimirRegistro.aspx.vb" Inherits="HorasExtrasWeb.ImprimirRegistro" %>
<!DOCTYPE html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../css/w3.css" rel="stylesheet" type="text/css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="w3-center w3-border w3-small">
            <b>
                <asp:Label ID="Label1" runat="server" Text="FORMULARIO PARA PAGO DE HORAS EXTRAORDINARIAS Y SUPLEMENTARIAS" 
                    CssClass="w3-tiny" />
            </b>
        </div>
        <div>
            <table class="w3-border w3-tiny" style="width: 100%;">
                <tr>
                    <td>
                        <b>
                            <asp:Label ID="Label2" runat="server" Text="PERÍODO:" CssClass="w3-tiny" />
                        </b>
                    </td>
                    <td>
                        <asp:Label ID="lblPeriodo" runat="server" Text="lblPeriodo" CssClass="w3-tiny"/>
                    </td>
                    <td>
                        <b>
                            <asp:Label ID="Label3" runat="server" Text="COLABORADOR:" CssClass="w3-tiny"/>
                        </b>
                    </td>
                    <td>
                        <asp:Label ID="lblColaborador" runat="server" Text="lblColaborador" CssClass="w3-tiny"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>
                            <asp:Label ID="Label4" runat="server" Text="CARGO:" CssClass="w3-tiny"/>
                        </b>
                    </td>
                    <td>
                        <asp:Label ID="lblCargo" runat="server" Text="lblCargo" CssClass="w3-tiny"/>
                    </td>
                    <td>
                        <b>
                            <asp:Label ID="Label5" runat="server" Text="LOCALIDAD:" CssClass="w3-tiny"/>
                        </b>
                    </td>
                    <td>
                        <asp:Label ID="lblLocalidad" runat="server" Text="lblLocalidad" CssClass="w3-tiny"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>
                            <asp:Label ID="Label6" runat="server" Text="DPTO./UNIDAD/P de V:" CssClass="w3-tiny"/>
                        </b>
                    </td>
                    <td>
                        <asp:Label ID="lblDepartamento" runat="server" Text="lblDepartamento" CssClass="w3-tiny"/>
                    </td>
                </tr>
            </table>
        </div>
        <div class="w3-border">
            <asp:Label ID="Label8" runat="server" Font-Size="6pt">
            Solicito se sirva autorizar el pago de las horas suplementarias/extraordinarias del período indicado, de acuerdo al 
            detalle de permisos por recuperar y al registro de ingresos y salidas correspondientes administrado por Desarrollo Humano; 
            todo esto en apego a lo establecido por el Código del Trabajo, el Reglamento Interno de Trabajo y la política corporativa 
            vigente. Los periodos de tiempo otorgados como "permisos recuperables" (Registro de Salida de Personal) serán descontados 
            de las jornadas extendidas, siempre que corresponda. 
            </asp:Label>
        </div>
        <strong>
            <asp:Label ID="Label7" runat="server" Text="Total de Atrasos: " CssClass="w3-tiny"/>
            <asp:Label ID="lblAtrasos" runat="server" Text="0:00" CssClass="w3-tiny"/>
        </strong>
        <asp:Label ID="Label9" runat="server" CssClass="w3-tiny"
            Text="   - NOTA: Los Atrasos se descuentan de las Horas Suplementarias y Extraordinarias"/>
        <br />
        <div class="w3-border w3-tiny">
            <asp:Label ID="lblSuplementario" runat="server">
                DIAS AUTORIZADOS PARA LABORAR HORAS SUPLEMENTARIAS (fuera de la jornada legal de trabajo a partir de 17:30, 
                máximo 48 horas) CÓDIGO DEL TRABAJO
            </asp:Label>
        </div>
        <div>
            <asp:GridView ID="gvBiometrico50" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                onRowDatabound="GridView_RowDataBound"
                >
                <HeaderStyle CssClass="w3-gray w3-tiny"/>
                <FooterStyle CssClass="w3-center w3-tiny" Font-Bold="true" />
                <Columns>
                    <asp:TemplateField HeaderText="N°">
                        <ItemTemplate>
                            <asp:Label ID="Num" runat="server" Text='<%#Bind("Num") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Fecha">
                        <ItemTemplate>
                            <asp:Label ID="lblFecha" runat="server" Text='<%# Bind("Fecha", "{0:ddd-dd-MM-yy}") %>'/>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Hora Ingreso" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraIng" runat="server" Text='<%#Bind("Ingreso", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Hora Salida" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraSal" runat="server" Text='<%#Bind("Salida", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Total horas" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraLab" runat="server" Text='<%#Bind("Laborado", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Permiso" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Permiso" runat="server" Text='<%#Bind("HorasPermiso", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Horas pagar" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Horas50" runat="server" Text='<%#Bind("Horas50", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Justificativo extensión jornada">
                        <ItemTemplate>
                            <asp:Label ID="Justificativo" runat="server" Text='<%# Bind("Justificativo") %>' Font-Size="6pt" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Biometrico" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="Biometrico" runat="server" Text='<%# Bind("Biometrico") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Aprobado" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="Aprobado" runat="server" Text='<%# Bind("Aprobado") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="A*">
                        <ItemTemplate>
                            <asp:Label ID="lblAprobado" runat="server" Text='NO' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="w3-tiny" />
            </asp:GridView>            
        </div>
        <div class="w3-right-align">
            <strong>
                <asp:Label ID="Label10" runat="server" Text="*Aprobado" CssClass="w3-tiny"/>
            </strong>
        </div>
        <div class="w3-border w3-tiny">
            <asp:Label ID="lblExtra" runat="server">
                DIAS AUTORIZADOS PARA LABORAR HORAS EXTRAORDINARIAS (días feriados, y fines de semana, máximo  24 horas) CÓDIGO DEL TRABAJO
            </asp:Label>
        </div>
        <div>
            <asp:GridView ID="gvBiometrico100" runat="server" AutoGenerateColumns="False" ShowFooter="True"
                onRowDatabound="GridView_RowDataBound"
                >
                <HeaderStyle CssClass="w3-gray w3-tiny" />
                <FooterStyle CssClass="w3-center w3-tiny" Font-Bold="true" />
                <Columns>
                    <asp:TemplateField HeaderText="N°">
                        <ItemTemplate>
                            <asp:Label ID="Num" runat="server" Text='<%#Bind("Num") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Fecha">
                        <ItemTemplate>
                            <asp:Label ID="lblFecha" runat="server" Text='<%# Bind("Fecha", "{0:ddd-dd-MM-yy}") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Hora Ingreso" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraIng" runat="server" Text='<%#Bind("Ingreso", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Hora Salida" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraSal" runat="server" Text='<%#Bind("Salida", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Total horas" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="HoraLab" runat="server" Text='<%#Bind("Laborado", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Recuperar" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Recuperar" runat="server" Text='<%#Bind("HorasRecuperar", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Horas pagar" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Horas100" runat="server" Text='<%#Bind("Horas100", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Justificativo extensión jornada">
                        <ItemTemplate>
                            <asp:Label ID="Justificativo" runat="server" Text='<%# Bind("Justificativo") %>' Font-Size="6pt" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Biometrico" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="Biometrico" runat="server" Text='<%# Bind("Biometrico") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Aprobado" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="Aprobado" runat="server" Text='<%# Bind("Aprobado") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="A*">
                        <ItemTemplate>
                            <asp:Label ID="lblAprobado" runat="server" Text='NO' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="w3-tiny" />
            </asp:GridView>
        </div>
        <br />
        <br />
        <div>
            <table style="width: 100%;" class="w3-center w3-tiny">
                <tr>
                    <td class="w3-border-bottom">                        
                    </td>
                    <td class="w3-border-bottom">                        
                    </td>
                    <td class="w3-border-bottom">                        
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblSolicitante" runat="server" Text="lblSolicitante" />
                        <br />
                        <asp:Label ID="Label12" runat="server" Text="Solicitante" />
                    </td>
                    <td>
                        <asp:Label ID="lblSupervisor" runat="server" Text="lblSupervisor" />
                        <br />
                        <asp:Label ID="Label13" runat="server" Text="Supervisor inmediato" />
                    </td>
                    <td>
                        <asp:Label ID="lblJefe" runat="server" Text="lblJefe" />
                        <br />
                        <asp:Label ID="Label14" runat="server" Text="Gerente/Jefe Dpto." />
                    </td>
                </tr>
            </table>
        </div>
        <div class="w3-center w3-gray w3-border">
            <b>
                <asp:Label ID="Label16" runat="server" Text="Nota:" Font-Size="8pt" />
            </b>
            <br />
            <asp:Label ID="Label15" runat="server" Font-Size="7pt">
            Entregar con la firma de aprobación de la Gerencia/Jefatura respectiva en Desarrollo Humano para procesamiento, 
            hasta la fecha del mes que corresponda; caso contrario no procederá el pago respectivo.
            </asp:Label>
        </div>
        <div class="w3-border">
            <div class="w3-center">
                <b>
                    <asp:Label ID="Label17" runat="server" Text="ESPACIO RESERVADO PARA EL DPTO. DE DESARROLLO HUMANO" CssClass="w3-tiny" />
                </b>
            </div>
            <asp:Label ID="Label18" runat="server" Text="Observaciones:" CssClass="w3-tiny"/>
            <br />
            <br />
            <table style="width: 100%;" class="w3-tiny">
                <tr>
                    <td class="w3-border-bottom">Fecha:</td>
                    <td></td>
                    <td class="w3-border-bottom">&nbsp;</td>
                    <td></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td></td>
                    <td class="w3-center">Analista DDHH</td>
                    <td></td>
                </tr>
            </table>
        </div>
        <br />
    </form>
</body>
</html>
