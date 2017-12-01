<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Wui/Maestro.Master" CodeBehind="Atrasos.aspx.vb" Inherits="HorasExtrasWeb.Atrasos" %>
<%@ MasterType virtualpath="~/Wui/Maestro.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="w3-container w3-center w3-panel w3-blue">
        <h2 class="w3-opacity" style="text-shadow:2px 2px 0 #444">Registro de Atrasos</h2>
    </div>
    <style type="text/css">
    .submit {
        text-align:right;
        background:url(../icons/impresora.ico) no-repeat left;
        background-color:Turquoise;
        font-size:75%;
    }
</style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div>
    </div>
    <div runat="server" visible="false" id="divError">
            <asp:Label ID="lblError" runat="server" Text="" Visible="false" CssClass="w3-panel w3-red"/>
    </div>
    <div>
        <table>
            <tr>
                <td>
                    <asp:Button ID="btnPrint1" runat="server" Text="Imprimir" CssClass="submit" Width="100px" />
                </td>
                <td>
                    <asp:Label ID="Label9" runat="server" Text="Es OBLIGATORIO imprimir y firmar los Atrasos" CssClass="w3-tiny w3-purple"/>
                </td>
            </tr>
        </table>
    </div>
    <div>
        <asp:GridView ID="gvAtrasos" runat="server" AutoGenerateColumns="False"
            OnRowEditing="GridView_RowEditing" 
            OnRowCancelingEdit="GridView_RowCancelingEdit"
            OnRowUpdating="GridView_RowUpdating" ShowHeaderWhenEmpty="True" 
            onRowDatabound="GridView_RowDataBound"
            ShowFooter="True" 
                >
            <HeaderStyle CssClass="w3-indigo w3-center w3-small" />
            <FooterStyle CssClass="w3-gray w3-center" />
            <Columns>
                <asp:TemplateField HeaderText="Codigo" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="CodigoEmp" runat="server" Text='<%#Bind("CodigoEmp") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Acción">
                    <EditItemTemplate>
                        <asp:ImageButton ID="ButtonUpdate" runat="server" CommandName="Update" ImageUrl="../icons/guardar.ico" ToolTipText="Guardar" />
                        <asp:ImageButton ID="ButtonCancel" runat="server" CommandName="Cancel" ImageUrl="../icons/regresar.ico" ToolTipText="Cancelar" />
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:ImageButton ID="ButtonEdit" runat="server" CommandName="Edit" ImageUrl="../icons/editar.ico" ToolTipText="Modificar" />
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
                    <EditItemTemplate>
                        <asp:TextBox ID="Justificativo" runat="server" Text='<%#Bind("Justificativo") %>' TextMode="MultiLine" Columns="100" Rows="3"/>
                        <br>
                        <asp:Label ID="lblJustVal" runat="server" Text="" Visible="false"/>
                        </br>
                    </EditItemTemplate>
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
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
