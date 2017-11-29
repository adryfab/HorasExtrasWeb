<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Wui/Maestro.Master" CodeBehind="Aprobacion.aspx.vb" Inherits="HorasExtrasWeb.Aprobacion" %>
<%@ MasterType virtualpath="~/Wui/Maestro.Master" %>
<%@ OutputCache Location="None" NoStore="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../css/w3.css" rel="stylesheet" type="text/css" />
    <script type = "text/javascript">
        function Confirm() {
            var confirm_value = document.createElement("INPUT");
            confirm_value.type = "hidden";
            confirm_value.name = "confirm_value";
            if (confirm("¿Está seguro?")) {
                confirm_value.value = "Si";
            } else {
                confirm_value.value = "No";
            }
            document.forms[0].appendChild(confirm_value);
        }
    </script>
    <script type = "text/javascript">
        function ConfirmAtraso() {
            var confirm_value = document.createElement("INPUT");
            confirm_value.type = "hidden";
            confirm_value.name = "confirm_value";
            if (confirm("¿Está seguro?")) {
                confirm_value.value = "Si";
            } else {
                confirm_value.value = "No";
            }
            document.forms[0].appendChild(confirm_value);
        }
    </script>
    <script src="../script/jquery-1.5.2.min.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="w3-container w3-center w3-panel w3-blue">
        <h2 class="w3-opacity" style="text-shadow:2px 2px 0 #444">Aprobaciones</h2>
    </div>
    <div id="id01" class="w3-modal" runat="server" visible="false">
        <div class="w3-modal-content">
            <div class="w3-container">
                <span onclick="document.getElementById('ContentPlaceHolder1_id01').style.display='none'" class="w3-button w3-display-topright">&times;</span>
                <p>Faltan registros por justificar o eliminar del empleado que desea aprobar</p>
            </div>
        </div>
    </div>
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server"/>
        <ajaxToolkit:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0">
            <ajaxToolkit:TabPanel runat="server" HeaderText="Horas Extras" ID="TabPanel1">
                <ContentTemplate>
                    <div style="overflow:auto;">
                        <asp:GridView ID="gvAprobar" runat="server" AutoGenerateColumns="False" 
                            onrowcommand="GridView_RowCommand"
                            onrowdatabound="GridView_RowDataBound" 
                            >
                            <HeaderStyle CssClass="w3-indigo" />
                            <AlternatingRowStyle CssClass="w3-light-grey" />
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ButtonMas" runat="server" ImageUrl="../icons/plus.gif" CommandName="PlusMas" 
                                            CommandArgument='<%# Container.DataItemIndex %>' 
                                            />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Código">
                                    <ItemTemplate>
                                        <asp:Label ID="NOMINA_ID" runat="server" Text='<%#Bind("NOMINA_ID") %>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"/>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Nombre">
                                    <ItemTemplate>
                                        <asp:Label ID="NOMBRE" runat="server" Text='<%#Bind("NOMBRE") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Apellido">
                                    <ItemTemplate>
                                        <asp:Label ID="APELLIDO" runat="server" Text='<%#Bind("APELLIDO") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Suplementarias">
                                    <ItemTemplate>
                                        <asp:Label ID="SUPLEMENTARIAS" runat="server" Text='<%#Bind("SUPLEMENTARIAS") %>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"/>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Extraordinarias">
                                    <ItemTemplate>
                                        <asp:Label ID="EXTRAORDINARIAS" runat="server" Text='<%#Bind("EXTRAORDINARIAS") %>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"/>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UsuarioSuper" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="UsuarioSuper" runat="server" Text='<%#Bind("UsuarioSuper") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="FechaSuper" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="FechaSuper" runat="server" Text='<%#Bind("FechaSuper") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UsuarioJefe" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="UsuarioJefe" runat="server" Text='<%#Bind("UsuarioJefe") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="FechaJefe" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="FechaJefe" runat="server" Text='<%#Bind("FechaJefe") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SUPERVISOR" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="SUPERVISOR" runat="server" Text='<%#Bind("SUPERVISOR") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Acción" Visible="False">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ButtonAprobar" runat="server" CommandName="aprobar" ImageUrl="../icons/aceptar.ico"
                                            OnClick="OnConfirm" OnClientClick="Confirm()"/>
                                        <asp:ImageButton ID="ButtonRechazar" runat="server" CommandName="rechazar" ImageUrl="../icons/rechazar.ico"
                                            OnClick="OnConfirm" OnClientClick="Confirm()" Visible="false"/>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Estado" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAprobado" runat="server" Text="Aprobado" Visible="false"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <br>
                        <tr id="trmostrar" runat="server" visible="False">
                            <td runat="server">
                                <div>
                                    <asp:GridView ID="gvBiometrico" runat="server" AutoGenerateColumns="False" 
                                        OnRowDataBound="GridViewDetalle_RowDataBound" 
                                        OnRowDeleting="GridView_RowDeleting">
                                        <AlternatingRowStyle CssClass="w3-light-grey" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Acción">
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="ButtonDelete" runat="server" CommandName="Delete" ImageUrl="../icons/eliminar.ico" ToolTipText="Elminar" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Codigo" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="Codigo" runat="server" Text='<%#Bind("CodigoEmp") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Dia">
                                                <ItemTemplate>
                                                    <asp:Label ID="Dia" runat="server" Text='<%#Bind("Dia") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Fecha">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblFecha" runat="server" Text='<%# Bind("Fecha", "{0:dd/MM/yyyy}") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Ingreso">
                                                <ItemTemplate>
                                                    <asp:Label ID="HoraIng" runat="server" Text='<%#Bind("Ingreso", "{0: H:mm}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Salida">
                                                <ItemTemplate>
                                                    <asp:Label ID="HoraSal" runat="server" Text='<%#Bind("Salida", "{0: H:mm}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Laborado">
                                                <ItemTemplate>
                                                    <asp:Label ID="HoraLab" runat="server" Text='<%#Bind("Laborado", "{0: H:mm}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Atrasado" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="HoraAtr" runat="server" Text='<%#Bind("Atrasado", "{0: H:mm}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Anticipado" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="HoraAnt" runat="server" Text='<%#Bind("Anticipado", "{0: H:mm}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Permiso">
                                                <ItemTemplate>
                                                    <asp:Label ID="HorasPermiso" runat="server" Text='<%#Bind("HorasPermiso", "{0: H:mm}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Recuperar">
                                                <ItemTemplate>
                                                    <asp:Label ID="HorasRecuperar" runat="server" Text='<%#Bind("HorasRecuperar", "{0: H:mm}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="0%" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="Hora0" runat="server" Text='<%#Bind("Horas0", "{0: H:mm}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="50%">
                                                <ItemTemplate>
                                                    <asp:Label ID="Horas50" runat="server" Text='<%#Bind("Horas50", "{0: H:mm}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="100%">
                                                <ItemTemplate>
                                                    <asp:Label ID="Horas100" runat="server" Text='<%#Bind("Horas100", "{0: H:mm}") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Justificativo">
                                                <ItemTemplate>
                                                    <asp:Label ID="Justificativo" runat="server" Text='<%# Bind("Justificativo") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="HorasExtrasId" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="HorasExtrasId" runat="server" Text='<%#Bind("HorasExtrasId") %>' />
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
                                            <asp:TemplateField HeaderText="Acción">
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="ButtonAprobar" runat="server" CommandName="aprobar" ImageUrl="../icons/aceptar.ico" OnClick="OnConfirmDetalle" OnClientClick="Confirm()" />
                                                    <asp:ImageButton ID="ButtonRechazar" runat="server" CommandName="rechazar" ImageUrl="../icons/rechazar.ico" OnClick="OnConfirmDetalle" OnClientClick="Confirm()" Visible="false" />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Estado">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblAprobado" runat="server" Text="Aprobado" Visible="false" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Aprobado" Visible="False">
                                                <ItemTemplate>
                                                    <asp:Label ID="Aprobado" runat="server" Text='<%#Bind("Aprobado") %>' />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <HeaderStyle CssClass="w3-indigo w3-center w3-small" />
                                    </asp:GridView>
                                </div>
                            </td>
                        </tr>
                        <br>
                    </div>
                </ContentTemplate>
            </ajaxToolkit:TabPanel>
            <ajaxToolkit:TabPanel ID="TabPanel2" runat="server" HeaderText="Atrasos">
                <ContentTemplate>
                    <div>
                        <asp:GridView ID="gvAtrasos" runat="server" AutoGenerateColumns="False"
                            onrowdatabound="GridViewAtrasos_RowDataBound" 
                                >
                            <HeaderStyle CssClass="w3-indigo w3-center w3-small" />
                            <FooterStyle CssClass="w3-gray w3-center w3-small" />
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
                                        <asp:Label ID="Tipo" runat="server" Text='<%#Bind("Tipo") %>' />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"/>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Justificativo">
                                    <ItemTemplate>
                                        <asp:Label ID="Justificativo" runat="server" Text='<%# Bind("Justificativo") %>' />
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
                                <asp:TemplateField HeaderText="Acción" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ButtonAprobar" runat="server" CommandName="aprobar" ImageUrl="../icons/aceptar.ico"
                                            OnClick="OnConfirmAtraso" OnClientClick="ConfirmAtraso()"/>
                                        <asp:ImageButton ID="ButtonRechazar" runat="server" CommandName="rechazar" ImageUrl="../icons/rechazar.ico"
                                            OnClick="OnConfirmAtraso" OnClientClick="ConfirmAtraso()" Visible="false"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Estado">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAtrasos" runat="server" Text="Aprobado" Visible="false"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>                    
                </ContentTemplate>
            </ajaxToolkit:TabPanel>
        </ajaxToolkit:TabContainer>
    </div>
    <br>
</asp:Content>
