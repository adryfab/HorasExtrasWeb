<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="Maestro.Master" CodeBehind="Login.aspx.vb" 
    Inherits="HorasExtrasWeb.Login"%>
<%@ MasterType virtualpath="Maestro.Master" %>
<%@ OutputCache Location="None" NoStore="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../css/font-awesome.min.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="w3-container w3-center w3-panel w3-blue">
        <h2 class="w3-opacity" style="text-shadow:2px 2px 0 #444">Iniciar sesión</h2>
    </div>
    <br />        
        <div class="w3-row w3-section">
            <div class="w3-rest">
                <div class="w3-col" style="width:30px">
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/icons/home1.png" />
                </div>
                <asp:TextBox ID="txtDomain" Runat="server" Text="CENTRAL" class="w3-input w3-border" style="width:20%" placeholder="Dominio" />
            </div>
            <div class="w3-rest">
                <div class="w3-col" style="width:30px">
                    <asp:Image ID="Image2" runat="server" ImageUrl="~/icons/account_circle1.png" />
                </div>
                <asp:TextBox ID="txtUsername" Runat="server" class="w3-input w3-border" style="width:20%" placeholder="Nombre de Usuario" />
            </div>
            <div class="w3-rest">
                <div class="w3-col" style="width:30px">
                    <asp:Image ID="Image3" runat="server" ImageUrl="~/icons/create1.png" />
                </div>
                <asp:TextBox ID="txtPassword" Runat="server" TextMode="Password" class="w3-input w3-border" style="width:20%" 
                    placeholder="Contraseña"/>
            </div>
            <asp:Button ID="btnLogin" Runat="server" Text="Inicio de sesión" OnClick="Login_Click" 
                class="w3-button w3-blue-grey w3-section w3-ripple w3-padding" />
        </div>

    <br />
    <div class="w3-panel w3-pale-red">
        <asp:Label ID="errorLabel" Runat="server" ForeColor="#ff3300"></asp:Label>
    </div> 
    <br>
    <br>
    <br>
    <br>
    <br>
    </asp:Content>
