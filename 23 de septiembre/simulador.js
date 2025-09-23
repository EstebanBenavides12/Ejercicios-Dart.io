/* app.js
   Implementación de la actividad:
   - Consume candidatos.json y administrador.json
   - Permite iniciar / cerrar elecciones (solo admin)
   - Genera interfaz dinámica para votar (clic en foto -> confirm)
   - Guarda votos y estado en localStorage
   - Muestra resultados al cerrar elecciones
*/

// URLs proporcionadas en la actividad (tal como aparecen en el PDF)
const CANDIDATES_URL = "https://raw.githubusercontent.com/CesarMCuellarCha/apis/refs/heads/main/candidatos.json";
const ADMIN_URL_1 = "https://raw.githubusercontent.com/CesarMCuellarCha/Elecciones/refs/heads/main/administrador.json";
const ADMIN_URL_2 = "https://raw.githubusercontent.com/cesarmcuellar/Elecciones/refs/heads/main/administrador.json"; // fallback

// Keys en localStorage
const LS_STATE = "elecciones_estado"; // { open: bool, admin: 'username' }
const LS_VOTES = "elecciones_votos"; // { candidateId: count, ... }
const LS_CANDIDATES = "elecciones_candidatos"; // cached candidates

// Elementos DOM
const statusEl = document.getElementById("status");
const votingArea = document.getElementById("voting-area");
const resultsArea = document.getElementById("results-area");
const resultsList = document.getElementById("results-list");
const btnLogin = document.getElementById("btn-login");
const btnStart = document.getElementById("btn-start");
const btnClose = document.getElementById("btn-close");
const btnResults = document.getElementById("btn-results");
const btnBackToVote = document.getElementById("btn-back-to-vote");
const btnReset = document.getElementById("btn-reset");

const modal = document.getElementById("modal");
const adminForm = document.getElementById("admin-form");
const adminUsernameInput = document.getElementById("admin-username");
const adminPasswordInput = document.getElementById("admin-password");
const modalCancel = document.getElementById("modal-cancel");

// Estado runtime
let candidates = [];
let adminData = null; // datos traídos desde administrador.json
let state = loadState(); // { open: bool, admin: username|null }
let votes = loadVotes(); // { candidateId: count }

// Inicialización
init();

async function init(){
  statusEl.textContent = "Cargando datos...";
  attachEventListeners();

  // Cargar candidatos (y caché local)
  try {
    const fetched = await fetchCandidates();
    candidates = fetched;
    // Añadir candidato en blanco si no existe (según consideración 1)
    ensureBlankCandidate();
    saveCandidatesToCache();
  } catch (err) {
    console.error("Error cargando candidatos:", err);
    // intentar cargar del cache
    const cached = localStorage.getItem(LS_CANDIDATES);
    if (cached) {
      candidates = JSON.parse(cached);
      console.warn("Usando candidatos cacheados.");
    } else {
      statusEl.textContent = "No fue posible cargar candidatos.";
      return;
    }
  }

  // Cargar admin (intenta ambas URLs)
  try {
    adminData = await fetchAdmin();
  } catch (err) {
    console.warn("No se pudo cargar administrador desde la(s) URL(s).", err);
    adminData = null;
  }

  renderUI();
  statusEl.textContent = state.open ? "Elecciones ABIERTAS" : "Elecciones CERRADAS";
}

// ---------- Fetch helpers ----------
async function fetchCandidates(){
  const resp = await fetch(CANDIDATES_URL);
  if (!resp.ok) throw new Error("HTTP " + resp.status);
  const data = await resp.json();
  // Se espera que data sea array de candidatos
  if (!Array.isArray(data)) {
    console.warn("Formato candidatos inesperado, se intenta extraer array.");
    return Array.isArray(data.candidatos) ? data.candidatos : [];
  }
  return data;
}

async function fetchAdmin(){
  // intentamos varias URL (en el PDF aparecen variantes)
  for (const url of [ADMIN_URL_1, ADMIN_URL_2]) {
    try {
      const r = await fetch(url);
      if (!r.ok) throw new Error("status " + r.status);
      const d = await r.json();
      // Puede venir como objeto o array. Normalizamos:
      // Si es array y tiene un objeto con usuario/clave, lo usamos; si es object, lo devolvemos.
      if (Array.isArray(d) && d.length) return d;
      return d;
    } catch (err) {
      console.info("admin fetch falló en", url, err);
    }
  }
  throw new Error("No se pudo obtener administrador");
}

// ---------- LocalStorage helpers ----------
function saveState(){
  localStorage.setItem(LS_STATE, JSON.stringify(state));
}
function loadState(){
  try {
    const s = JSON.parse(localStorage.getItem(LS_STATE));
    if (s && typeof s.open === "boolean") return s;
  } catch{}
  return { open: false, admin: null };
}
function saveVotes(){
  localStorage.setItem(LS_VOTES, JSON.stringify(votes));
}
function loadVotes(){
  try {
    const v = JSON.parse(localStorage.getItem(LS_VOTES));
    if (v && typeof v === "object") return v;
  } catch{}
  // inicializar contadores a 0
  return {};
}
function saveCandidatesToCache(){
  localStorage.setItem(LS_CANDIDATES, JSON.stringify(candidates));
}

// ---------- UI rendering ----------
function renderUI(){
  // estado botones
  const isAdminLogged = !!state.admin;
  btnLogin.textContent = isAdminLogged ? `Admin: ${state.admin}` : "Iniciar sesión Administrador";
  btnStart.disabled = !isAdminLogged || state.open;
  btnClose.disabled = !isAdminLogged || !state.open;
  btnResults.disabled = !isAdminLogged && !state.open && !hasAnyVotes();
  // mostrar area de votación o resultados según estado
  votingArea.classList.remove("hidden");
  resultsArea.classList.add("hidden");
  renderCandidates();
}

function renderCandidates(){
  votingArea.innerHTML = "";
  // Si elecciones están cerradas, no permitir votar
  const votingAllowed = state.open === true;
  candidates.forEach(c => {
    const card = document.createElement("div");
    card.className = "card";

    // imagen clickeable
    const img = document.createElement("img");
    img.src = c.foto || c.imagen || c.photo || placeholderImage();
    img.alt = c.nombre || c.name || "Candidato";
    img.title = "Haga clic para votar";
    img.addEventListener("click", () => {
      if (!votingAllowed) {
        alert("Las elecciones están cerradas. No se puede votar.");
        return;
      }
      handleVoteClick(c);
    });

    const h = document.createElement("h3");
    h.textContent = c.nombre || c.name || "Sin nombre";

    const p = document.createElement("p");
    p.textContent = c.programa || c.program || c.curso || "";

    const meta = document.createElement("div");
    meta.className = "meta";
    const aprendiz = document.createElement("span");
    aprendiz.textContent = `Aprendiz: ${c.aprendiz || c.documento || "NNNNNNNNNN"}`;
    const ficha = document.createElement("span");
    ficha.textContent = `Ficha: ${c.ficha || c.ficha_num || "######"}`;

    meta.appendChild(aprendiz);
    meta.appendChild(ficha);

    card.appendChild(img);
    card.appendChild(h);
    card.appendChild(p);
    card.appendChild(meta);

    // Si ya tiene votos, mostrar badge (opcional)
    const count = votes[getCandidateKey(c)] || 0;
    if (count > 0) {
      const badge = document.createElement("div");
      badge.style.marginTop = "8px";
      badge.style.fontWeight = "700";
      badge.textContent = `Votos: ${count}`;
      card.appendChild(badge);
    }

    votingArea.appendChild(card);
  });
}

function renderResults(){
  resultsList.innerHTML = "";
  // Build a list ordered by votes desc
  const results = candidates.map(c => {
    return {
      candidate: c,
      votes: votes[getCandidateKey(c)] || 0
    };
  }).sort((a,b) => b.votes - a.votes);

  results.forEach(r => {
    const row = document.createElement("div");
    row.className = "result-item";
    const img = document.createElement("img");
    img.src = r.candidate.foto || r.candidate.imagen || r.candidate.photo || placeholderImage();
    const info = document.createElement("div");
    info.className = "info";
    const name = document.createElement("div");
    name.style.fontWeight = "700";
    name.textContent = r.candidate.nombre || r.candidate.name || "Sin nombre";
    const program = document.createElement("div");
    program.style.color = "#666";
    program.textContent = r.candidate.programa || r.candidate.program || "";

    info.appendChild(name);
    info.appendChild(program);

    const count = document.createElement("div");
    count.className = "count";
    count.textContent = r.votes;

    row.appendChild(img);
    row.appendChild(info);
    row.appendChild(count);

    resultsList.appendChild(row);
  });
}

// ---------- Interacciones ----------
function attachEventListeners(){
  btnLogin.addEventListener("click", () => {
    openModal();
  });
  btnStart.addEventListener("click", () => {
    if (!confirm("¿Desea INICIAR las elecciones?")) return;
    state.open = true;
    saveState();
    statusEl.textContent = "Elecciones ABIERTAS";
    renderUI();
  });
  btnClose.addEventListener("click", () => {
    if (!confirm("¿Desea CERRAR las elecciones? Al cerrar se bloquearán nuevos votos y podrá ver los resultados.")) return;
    state.open = false;
    saveState();
    statusEl.textContent = "Elecciones CERRADAS";
    showResults();
  });
  btnResults.addEventListener("click", () => {
    showResults();
  });
  btnBackToVote.addEventListener("click", () => {
    resultsArea.classList.add("hidden");
    votingArea.classList.remove("hidden");
  });
  btnReset.addEventListener("click", () => {
    if (!confirm("Reiniciar datos de la demo (eliminar votos y estado). ¿Estás seguro?")) return;
    localStorage.removeItem(LS_VOTES);
    localStorage.removeItem(LS_STATE);
    localStorage.removeItem(LS_CANDIDATES);
    votes = {};
    state = { open: false, admin: null };
    saveState();
    renderUI();
    alert("Datos reiniciados. Refresca la página si algo no se actualiza.");
  });

  adminForm.addEventListener("submit", (e) => {
    e.preventDefault();
    performAdminLogin(adminUsernameInput.value.trim(), adminPasswordInput.value.trim());
  });
  modalCancel.addEventListener("click", closeModal);
}

// Modal
function openModal(){
  modal.classList.remove("hidden");
  adminUsernameInput.value = "";
  adminPasswordInput.value = "";
  adminUsernameInput.focus();
}
function closeModal(){
  modal.classList.add("hidden");
}

// Admin login flow
async function performAdminLogin(username, password){
  if (!adminData) {
    alert("No se pudo verificar el administrador. Verifica la conexión a la API.");
    closeModal();
    return;
  }

  // adminData puede ser objeto o array
  let ok = false;
  if (Array.isArray(adminData)) {
    ok = adminData.some(a =>
      (a.usuario === username || a.user === username || a.username === username) &&
      (a.clave === password || a.password === password || a.pass === password)
    );
  } else {
    // objeto
    const a = adminData;
    ok = (a.usuario === username || a.user === username || a.username === username) &&
         (a.clave === password || a.password === password || a.pass === password);
    // o si el objeto contiene credenciales dentro: intentar detectar arrays dentro del objeto:
    if (!ok) {
      for (const k in a) {
        if (Array.isArray(a[k])) {
          ok = a[k].some(u => (u.usuario === username || u.user === username) && (u.clave === password || u.password === password));
          if (ok) break;
        }
      }
    }
  }

  if (ok) {
    state.admin = username;
    saveState();
    alert("Ingreso autorizado. Ahora puede iniciar o cerrar las elecciones.");
    closeModal();
    renderUI();
  } else {
    alert("Credenciales inválidas. No está autorizado para iniciar/cerrar las elecciones.");
  }
}

// Votar
function handleVoteClick(candidate){
  const nombre = candidate.nombre || candidate.name || "Candidato";
  const confirmMsg = `¿Está seguro que desea votar por:\n\n${nombre}\n\nPulse Aceptar para confirmar.`;
  if (!confirm(confirmMsg)) {
    return; // no confirma -> regresa
  }

  const key = getCandidateKey(candidate);
  votes[key] = (votes[key] || 0) + 1;
  saveVotes();

  // Opcional: guardar log de votos (con timestamp) - no obligatorio pero útil
  appendVoteLog({ candidateKey: key, candidateName: nombre, date: new Date().toISOString() });

  alert("Voto registrado. Gracias por participar.");
  renderCandidates();
}

// Helpers
function getCandidateKey(c){
  // si tiene id o cedula o documento, usarlo; si no, usar su nombre + index
  return c.id || c.cedula || c.documento || (c.nombre ? normalizeKey(c.nombre) : JSON.stringify(c));
}
function normalizeKey(s){
  return s.toString().trim().toLowerCase().replace(/\s+/g,"_");
}
function placeholderImage(){
  // simple data URI placeholder (gris)
  return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(
    `<svg xmlns='http://www.w3.org/2000/svg' width='400' height='400'><rect fill='%23e9eef4' width='100%' height='100%'/><text x='50%' y='50%' fill='%23888' dominant-baseline='middle' text-anchor='middle' font-size='22'>Foto no disponible</text></svg>`
  );
}

function ensureBlankCandidate(){
  // Verifica si ya existe candidato "Blanco", si no, lo añade
  const found = candidates.some(c => (c.nombre && c.nombre.toLowerCase().includes("blanco")) || (c.name && c.name.toLowerCase().includes("blanco")));
  if (!found) {
    candidates.push({
      id: "BLANCO",
      nombre: "Voto en Blanco",
      programa: "Voto en Blanco",
      foto: null,
      aprendiz: "--------",
      ficha: "------"
    });
  }
}

function appendVoteLog(entry){
  const key = "elecciones_log";
  try {
    const arr = JSON.parse(localStorage.getItem(key)) || [];
    arr.push(entry);
    localStorage.setItem(key, JSON.stringify(arr));
  } catch(e){
    console.warn("No se pudo guardar log de votos", e);
  }
}

function hasAnyVotes(){
  return Object.keys(votes).length > 0 && Object.values(votes).some(n => n > 0);
}

function showResults(){
  renderResults();
  votingArea.classList.add("hidden");
  resultsArea.classList.remove("hidden");
  statusEl.textContent = "Resultados (Elecciones cerradas)";
}

// -- fin app.js --
