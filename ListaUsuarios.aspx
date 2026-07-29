<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CargarDatos();
        }
    }

    private void CargarDatos()
    {
        // Tus credenciales directas de SQL Server
        string cadenaConexion = "Server=s225sql01; Database=LaboratoryTest; User Id=qcsapp; Password=omerDBA;";
        
        // RECUERDA: Cambia 'usuarios' por el nombre real de tu tabla
        string consulta = "SELECT * FROM employee";

        using (SqlConnection conexion = new SqlConnection(cadenaConexion))
        {
            using (SqlCommand comando = new SqlCommand(consulta, conexion))
            {
                try
                {
                    SqlDataAdapter adaptador = new SqlDataAdapter(comando);
                    DataTable dt = new DataTable();
                    
                    conexion.Open();
                    adaptador.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        gvUsuarios.DataSource = dt;
                        gvUsuarios.DataBind();
                    }
                    else
                    {
                        lblMensaje.Text = "Conexión exitosa, pero la tabla no tiene registros.";
                    }
                }
                catch (Exception ex)
                {
                    lblMensaje.Text = "Error de conexión o consulta: " + ex.Message;
                }
            }
        }
    }
</script>

<html lang="es">
<head runat="server">
    <meta charset="UTF-8">
    <title>Lista de Usuarios - Emerson</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f9f9f9; }
        .contenedor { background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .grid-view th { background-color: #0056b3; color: white; padding: 10px; text-align: left; }
        .grid-view td { padding: 10px; border: 1px solid #dddddd; }
        .grid-view tr:nth-child(even) { background-color: #f2f2f2; }
        .error-msg { color: #cc0000; font-weight: bold; margin-top: 15px; display: block; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="contenedor">
            <h2>Registros de la Base de Datos (SQL Server)</h2>
            
            <asp:GridView ID="gvUsuarios" runat="server" AutoGenerateColumns="true" CssClass="grid-view">
            </asp:GridView>

            <asp:Label ID="lblMensaje" runat="server" CssClass="error-msg"></asp:Label>
        </div>
    </form>
</body>
</html>