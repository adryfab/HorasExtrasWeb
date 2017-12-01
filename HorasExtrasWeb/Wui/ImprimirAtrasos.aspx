<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ImprimirAtrasos.aspx.vb" Inherits="HorasExtrasWeb.ImprimirAtrasos" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../css/w3.css" rel="stylesheet" type="text/css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="w3-center w3-border w3-small">
            <b>
                <asp:Label ID="Label1" runat="server" Text="FORMULARIO DE REGISTRO DE ATRASOS" 
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
        <div>
            <asp:GridView ID="gvAtrasos" runat="server" AutoGenerateColumns="False"
                ShowFooter="True" 
                onRowDatabound="GridView_RowDataBound"
                    >
                <HeaderStyle CssClass="w3-center w3-tiny" />
                <FooterStyle CssClass="w3-center w3-tiny" />
                <RowStyle CssClass="w3-tiny" />
                <Columns>
                    <asp:TemplateField HeaderText="Codigo" Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="CodigoEmp" runat="server" Text='<%#Bind("CodigoEmp") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Dia">
                        <ItemTemplate>
                            <asp:Label ID="Dia" runat="server" Text='<%#Bind("Dia") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Fecha">
                        <ItemTemplate>
                            <asp:Label ID="Fecha" runat="server" Text='<%# Bind("Fecha", "{0:dd/MM/yyyy}") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Ingreso" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Ingreso" runat="server" Text='<%#Bind("Ingreso", "{0: H:mm}") %>'  />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center"/>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Tiempo" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Tiempo" runat="server" Text='<%#Bind("Tiempo", "{0: H:mm}") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center"/>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="CodNov" ItemStyle-HorizontalAlign="Center" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="CodNov" runat="server" Text='<%#Bind("CodNov") %>' />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center"/>
                    </asp:TemplateField>            
                    <asp:TemplateField HeaderText="Tipo" ItemStyle-HorizontalAlign="Center">
                        <ItemTemplate>
                            <asp:Label ID="Tipo" runat="server" Text='<%#Bind("Tipo") %>' Font-Size="6pt" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center"/>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Justificativo">
                        <ItemTemplate>
                            <asp:Label ID="Justificativo" runat="server" Text='<%# Bind("Justificativo") %>' Font-Size="6pt" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="AtrasosId" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="AtrasosId" runat="server" Text='<%#Bind("AtrasosId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Anio" Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="Anio" runat="server" Text='<%#Bind("Anio") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Periodo" Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="Periodo" runat="server" Text='<%#Bind("Periodo") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Activo" Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="Activo" runat="server" Text='<%#Bind("Activo") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Biometrico" Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="Biometrico" runat="server" Text='<%#Bind("Biometrico") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Aprobado" Visible="False">
                        <ItemTemplate>
                            <asp:Label ID="Aprobado" runat="server" Text='<%#Bind("Aprobado") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="A*">
                        <ItemTemplate>
                            <asp:Label ID="lblAprobado" runat="server" Text='NO' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <div class="w3-right-align">
            <strong>
                <asp:Label ID="Label10" runat="server" Text="*Aprobado" CssClass="w3-tiny"/>
            </strong>
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
                <asp:Label ID="Label16" runat="server" Text="Nota:" Font-Size="6pt" />
            </b>
            <br />
            <asp:Label ID="Label15" runat="server" Font-Size="6pt">
            Entregar con la firma de aprobación de la Gerencia/Jefatura respectiva en Desarrollo Humano para procesamiento, 
            hasta la fecha del mes que corresponda; caso contrario se procederá al descuento respectivo.
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
    </form>
</body>
</html>
