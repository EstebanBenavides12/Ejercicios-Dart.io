import { obtenerFichas } from './FichasADSO.js';
import { obtenerAprendices } from './AprendicesFicha.js';

let fichasData = null;
let aprendicesData = null;
let aprendicesAgrupados = {};

const selectFicha = document.getElementById('selectFicha');
const selectAprendiz = document.getElementById('selectAprendiz');
const inputNombres = document.getElementById('nombres');
const inputApellidos = document.getElementById('apellidos');
const inputEstado = document.getElementById('estado');
const inputPrograma = document.getElementById('inputPrograma');
const totalEvaluados = document.getElementById('totalEvaluados');
const totalPorEvaluar = document.getElementById('totalPorEvaluar');
const tablaJuicios = document.getElementById('tablaJuicios');
const usuarioSpan = document.getElementById('usuarioNombre');
const btnSalir = document.getElementById('btnSalir');

window.addEventListener('DOMContentLoaded', async () => {
    const usuario = localStorage.getItem('usuario');
    if (!usuario) {
        alert('Debe primero ingresar con un usuario y contraseña');
        window.location.href = '../Html/index.html';
        return;
    }
    usuarioSpan.textContent = usuario;

    fichasData = await obtenerFichas();
    cargarFichas();
});

function cargarFichas() {
    selectFicha.innerHTML = '<option value="">SELECCIONE</option>';
    fichasData.fichas.forEach(ficha => {
        const option = document.createElement('option');
        option.value = ficha.url;
        option.textContent = ficha.codigo;
        option.dataset.codigo = ficha.codigo;
        selectFicha.appendChild(option);
    });
}

selectFicha.addEventListener('change', async (e) => {
    const url = e.target.value;
    if (url) {
        aprendicesData = await obtenerAprendices(url);
        agruparAprendices();
        cargarAprendices();
        
        if (aprendicesData && aprendicesData.length > 0) {
            inputPrograma.value = aprendicesData[0].PROGRAMA || '';
        }
    } else {
        selectAprendiz.innerHTML = '<option value="">Seleccione primero una ficha</option>';
        limpiarDatos();
    }
});

function agruparAprendices() {
    aprendicesAgrupados = {};
    
    aprendicesData.forEach(registro => {
        const documento = registro['Número de Documento'];
        
        if (!aprendicesAgrupados[documento]) {
            aprendicesAgrupados[documento] = {
                documento: documento,
                nombres: registro.Nombre || '',
                apellidos: registro.Apellidos || '',
                estado: registro.Estado || '',
                programa: registro.PROGRAMA || '',
                evaluaciones: []
            };
        }
        
        aprendicesAgrupados[documento].evaluaciones.push({
            competencia: registro.Competencia || '',
            resultado: registro['Resultado de Aprendizaje'] || '',
            juicio: registro['Juicio de Evaluación'] || '',
            fechaHora: registro['Fecha y Hora del Juicio Evaluativo'] || '',
            instructor: registro['Funcionario que registro el juicio evaluativo'] || ''
        });
    });
}

function cargarAprendices() {
    selectAprendiz.innerHTML = '<option value="">Seleccione un aprendiz</option>';
    
    Object.keys(aprendicesAgrupados).forEach(documento => {
        const option = document.createElement('option');
        option.value = documento;
        option.textContent = documento;
        selectAprendiz.appendChild(option);
    });
}

selectAprendiz.addEventListener('change', (e) => {
    const documento = e.target.value;
    if (documento !== '') {
        const aprendiz = aprendicesAgrupados[documento];
        mostrarDatosAprendiz(aprendiz);
    } else {
        limpiarDatos();
    }
});

function mostrarDatosAprendiz(aprendiz) {
    inputNombres.value = aprendiz.nombres;
    inputApellidos.value = aprendiz.apellidos;
    inputEstado.value = aprendiz.estado;

    let evaluados = 0;
    let porEvaluar = 0;

    tablaJuicios.innerHTML = '';

    aprendiz.evaluaciones.forEach(evaluacion => {
        const juicio = evaluacion.juicio.toUpperCase();
        
        if (juicio === 'APROBADO') {
            evaluados++;
        } else if (juicio === 'POR EVALUAR') {
            porEvaluar++;
        }

        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${evaluacion.competencia}</td>
            <td>${evaluacion.resultado}</td>
            <td>${evaluacion.juicio}</td>
            <td>${evaluacion.fechaHora}</td>
            <td>${evaluacion.instructor}</td>
        `;
        tablaJuicios.appendChild(tr);
    });

    totalEvaluados.textContent = evaluados;
    totalPorEvaluar.textContent = porEvaluar;
}

function limpiarDatos() {
    inputNombres.value = '';
    inputApellidos.value = '';
    inputEstado.value = '';
    inputPrograma.value = '';
    totalEvaluados.textContent = '0';
    totalPorEvaluar.textContent = '0';
    tablaJuicios.innerHTML = '';
}

btnSalir.addEventListener('click', () => {
    localStorage.removeItem('usuario');
    window.location.href = '../Html/index.html';
});
