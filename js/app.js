// app.js — Inicialización principal

async function refreshAppData() {
  await Promise.all([
    loadAnimales(),
    loadReproduccion(),
    loadProduccion(),
    loadSalud(),
    loadVentas(),
    loadDetalleVenta(),
    loadDashboard()
  ]);
}

async function initApp() {
  const { error: testError } = await db
    .from('animales')
    .select('id')
    .limit(1);

  if (testError) {
    showToast('❌ Error de conexión: ' + testError.message, 'error');
    return;
  }

  await loadRazas();
  await refreshAppData();
  setupRealtime();
}