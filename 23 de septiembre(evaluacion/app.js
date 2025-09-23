// URL de la API
const API_URL = "https://raw.githubusercontent.com/CesarMCuellarCha/apis/main/SENA-CTPI.matriculados.json";

// Datos de acceso válidos
const VALID_USERNAME = "adso3064975";
const VALID_PASSWORD = "adso3064975";

// Esperar a que el DOM esté cargado
document.addEventListener("DOMContentLoaded", () => {
    // Manejar el envío del formulario de inicio de sesión
    const loginForm = document.getElementById("login-form");
    loginForm.addEventListener("submit", (e) => {
        e.preventDefault();
        const username = document.getElementById("username").value;
        const password = document.getElementById("password").value;

        if (username === VALID_USERNAME && password === VALID_PASSWORD) {
            localStorage.setItem("username", username);
            loginForm.reset();
            document.getElementById("login-section").style.display = "none";
            document.getElementById("app-section").style.display = "block";
            cargarDatos();
        } else {
            alert("Credenciales incorrectas. El nombre de usuario es 'adso3064975' y la contraseña es 'adso3064975'. Inténtalo de nuevo.");
        }
    });

    // Manejar el botón de salir
    const exitBtn = document.getElementById("exit-btn");
    exitBtn.addEventListener("click", () => {
        localStorage.clear();
        document.getElementById("app-section").style.display = "none";
        document.getElementById("login-section").style.display = "block";
        document.getElementById("aprendices-table-body").innerHTML = "";
        document.getElementById("ficha-select").innerHTML = '<option value="">Seleccione una opción</option>';
        document.getElementById("program-name").value = "";
    });
});


// Función para cargar los datos desde la API
function cargarDatos() {
    fetch(API_URL)
        .then(response => response.json())
        .then(data => {
            const fichas = [...new Set(data.map(item => item.CodigoFicha))];
            const fichaSelect = document.getElementById("ficha-select");

            // Llenar el selector de fichas
            fichas.forEach(ficha => {
                const option = document.createElement("option");
                option.value = ficha;
                option.textContent = ficha;
                fichaSelect.appendChild(option);
            });

            // Manejar el cambio en el selector de fichas
            fichaSelect.addEventListener("change", () => {
                const selectedFicha = fichaSelect.value;
                if (selectedFicha) {
                    const fichaData = data.filter(item => item.CodigoFicha === selectedFicha);
                    const programName = fichaData[0].NombrePrograma;
                    document.getElementById("program-name").value = programName;

                    // Guardar datos en localStorage
                    localStorage.setItem("codigoFicha", selectedFicha);
                    localStorage.setItem("nombrePrograma", programName);
                    localStorage.setItem("nivelFormacion", fichaData[0].NivelFormacion);
                    localStorage.setItem("estadoFicha", fichaData[0].EstadoFicha);

                    // Mostrar los aprendices en la tabla
                    mostrarAprendices(fichaData);
                }
            });
        })
        .catch(error => console.error("Error al cargar los datos:", error));
}

// Función para mostrar los aprendices en la tabla
function mostrarAprendices(fichaData) {
    const tableBody = document.getElementById("aprendices-table-body");
    tableBody.innerHTML = "";

    fichaData.forEach(aprendiz => {
        const row = document.createElement("tr");

        // Aplicar estilo si el estado es "Retiro Voluntario"
        if (aprendiz.EstadoAprendiz === "Retiro Voluntario") {
            row.classList.add("table-danger");
        }

        row.innerHTML = `
            <td>${aprendiz.TipoDocumento}</td>
            <td>${aprendiz.NumeroDocumento}</td>
            <td>${aprendiz.Nombre}</td>
            <td>${aprendiz.PrimerApellido}</td>
            <td>${aprendiz.SegundoApellido}</td>
            <td>${aprendiz.EstadoAprendiz}</td>
        `;
        tableBody.appendChild(row);
    });

    // Actualizar el pie de página
    const footerInfo = document.getElementById("footer-info");
    footerInfo.innerHTML = `
        <p><strong>Elaborado por:</strong> ${localStorage.getItem("username")}</p>
        <p><strong>Tecnólogo en Análisis y Desarrollo de Software</strong></p>
        <p><strong>Ficha:</strong> ${localStorage.getItem("codigoFicha")}</p>
    `;
}
