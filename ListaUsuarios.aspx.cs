using System;
using System.Data;
using System.Data.SqlClient;

namespace TuProyecto
{
    public partial class ListaUsuarios : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Evita recargar los datos si la página hace un PostBack
            if (!IsPostBack)
            {
                CargarDatos();
            }
        }

        private void CargarDatos()
        {
            // Cadena de conexión con tus datos de SQL Server
            string cadenaConexion = "Server=server01; Database=emerson; User Id=QCsapp; Password=apodaca300;";
            
            // Consulta SQL (Cambia 'usuarios' por el nombre real de tu tabla en la base de datos 'emerson')
            string consulta = "SELECT * FROM usuarios";

            using (SqlConnection conexion = new SqlConnection(cadenaConexion))
            {
                using (SqlCommand comando = new SqlCommand(consulta, conexion))
                {
                    try
                    {
                        SqlDataAdapter adaptador = new SqlDataAdapter(comando);
                        DataTable dt = new DataTable();
                        
                        conexion.Open();
                        adaptador.Fill(dt); // Ejecuta el SELECT y llena la tabla en memoria

                        if (dt.Rows.Count > 0)
                        {
                            gvUsuarios.DataSource = dt;
                            gvUsuarios.DataBind(); // Enlaza los datos al control visual
                        }
                        else
                        {
                            lblMensaje.Text = "Conexión exitosa, pero no se encontraron registros en la tabla.";
                        }
                    }
                    catch (Exception ex)
                    {
                        // Muestra el error exacto en pantalla si la conexión falla
                        lblMensaje.Text = "Error de conexión o consulta: " + ex.Message;
                    }
                }
            }
        }
    }
}