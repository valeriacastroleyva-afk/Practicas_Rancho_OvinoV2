// reproduccion.js — Empadres y partos

async function loadReproduccion() {
  loading('table-reproduccion');

  const { data, error } = await db
    .from('reproduccion')
    .select(`
      *,
      hembra:id_hembra(identificador,nombre),
      macho:id_macho(identificador,nombre)
    `)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('Error cargando reproducción:', error);
    showToast('Error cargando reproducción: ' + error.message, 'error');
    return;
  }

  const cont = document.getElementById('table-reproduccion');

  if (!data || !data.length) {
    cont.innerHTML = emptyState(
      '🐣',
      'No hay registros de reproducción'
    );
    return;
  }

  const rows = data.map(r => `
    <tr>
      <td>${r.hembra?.identificador || '—'}</td>
      <td>${r.macho?.identificador || '—'}</td>
      <td>${formatDate(r.fecha_empadre)}</td>
      <td>${formatDate(r.fecha_parto_estimada)}</td>
      <td>${formatDate(r.fecha_parto_real)}</td>
      <td>${r.numero_crias ?? '—'}</td>

      <td>
        ${badge(r.estado, {
          gestando: 'badge-gestando',
          pario: 'badge-pario',
          fallido: 'badge-fallido'
        })}
      </td>

      <td>${r.notas || r.observaciones || '—'}</td>

      <td>
        <div style="display:flex;gap:0.3rem">
          <button
            class="btn btn-edit"
            onclick="openEditParto('${r.id}')">
            ✏️
          </button>

          <button
            class="btn btn-danger"
            onclick="deleteRecord('reproduccion','${r.id}')">
            🗑
          </button>
        </div>
      </td>
    </tr>
  `).join('');

  cont.innerHTML = `
    <table>
      <thead>
        <tr>
          <th>Hembra</th>
          <th>Macho</th>
          <th>Empadre</th>
          <th>Parto Est.</th>
          <th>Parto Real</th>
          <th>Crías</th>
          <th>Estado</th>
          <th>Notas</th>
          <th>Acc.</th>
        </tr>
      </thead>

      <tbody>${rows}</tbody>
    </table>
  `;
}


// Registrar un empadre nuevo
async function saveReproduccion() {
  const payload = {
    id_hembra: document.getElementById('r-hembra').value,
    id_macho: document.getElementById('r-macho').value,
    fecha_empadre: document.getElementById('r-empadre').value,
    fecha_parto_real:
      document.getElementById('r-parto-real').value || null,

    numero_crias: document.getElementById('r-crias').value
      ? parseInt(document.getElementById('r-crias').value, 10)
      : null,

    estado: document.getElementById('r-estado').value,

    observaciones:
      document.getElementById('r-observaciones').value.trim() || null,

    notas:
      document.getElementById('r-notas-repro').value.trim() || null
  };

  if (
    !payload.id_hembra ||
    !payload.id_macho ||
    !payload.fecha_empadre
  ) {
    showToast(
      'Hembra, macho y fecha son obligatorios',
      'error'
    );
    return;
  }

  const { error } = await db
    .from('reproduccion')
    .insert(payload);

  if (error) {
    console.error('Error registrando empadre:', error);
    showToast('Error: ' + error.message, 'error');
    return;
  }

  showToast('✅ Empadre registrado');

  closeModal('modal-reproduccion');

  resetReproduccionForm();

  await refreshAppData();
}


// Cargar los datos existentes en el modal de edición
async function openEditParto(id) {
  const { data: parto, error } = await db
    .from('reproduccion')
    .select('*')
    .eq('id', id)
    .single();

  if (error || !parto) {
    console.error('Error cargando empadre:', error);
    showToast('Error cargando el empadre', 'error');
    return;
  }

  // Si todavía no hay animales cargados, cargarlos primero
  if (!animalesCache || animalesCache.length === 0) {
    await loadAnimales();
  } else {
    populateAnimalSelects();
  }

  const selectHembra = document.getElementById('ep-hembra');
  const selectMacho = document.getElementById('ep-macho');

  document.getElementById('ep-id').value = parto.id || '';

  selectHembra.value = parto.id_hembra || '';
  selectMacho.value = parto.id_macho || '';

  document.getElementById('ep-empadre').value =
    parto.fecha_empadre || '';

  document.getElementById('ep-parto-real').value =
    parto.fecha_parto_real || '';

  document.getElementById('ep-crias').value =
    parto.numero_crias ?? '';

  document.getElementById('ep-estado').value =
    parto.estado || 'gestando';

  document.getElementById('ep-observaciones').value =
    parto.observaciones || parto.notas || '';

  openModal('modal-editar-parto');
}


// Guardar los cambios del empadre
async function updateParto() {
  const id = document.getElementById('ep-id').value;

  const payload = {
    id_hembra: document.getElementById('ep-hembra').value,
    id_macho: document.getElementById('ep-macho').value,
    fecha_empadre: document.getElementById('ep-empadre').value,

    fecha_parto_real:
      document.getElementById('ep-parto-real').value || null,

    numero_crias: document.getElementById('ep-crias').value !== ''
      ? parseInt(document.getElementById('ep-crias').value, 10)
      : null,

    estado: document.getElementById('ep-estado').value,

    observaciones:
      document.getElementById('ep-observaciones').value.trim() || null
  };

  if (!id) {
    showToast(
      'No se encontró el ID del empadre',
      'error'
    );
    return;
  }

  if (
    !payload.id_hembra ||
    !payload.id_macho ||
    !payload.fecha_empadre
  ) {
    showToast(
      'Hembra, macho y fecha de empadre son obligatorios',
      'error'
    );
    return;
  }

  const { error } = await db
    .from('reproduccion')
    .update(payload)
    .eq('id', id);

  if (error) {
    console.error('Error actualizando empadre:', error);
    showToast('Error guardando cambios: ' + error.message, 'error');
    return;
  }

  showToast('✅ Empadre actualizado');

  closeModal('modal-editar-parto');

  await refreshAppData();
}


// Limpiar el formulario de registro nuevo
function resetReproduccionForm() {
  const campos = [
    'r-hembra',
    'r-macho',
    'r-empadre',
    'r-parto-real',
    'r-crias',
    'r-observaciones',
    'r-notas-repro'
  ];

  campos.forEach(id => {
    const elemento = document.getElementById(id);
    if (elemento) elemento.value = '';
  });

  const estado = document.getElementById('r-estado');

  if (estado) {
    estado.value = 'gestando';
  }
}
