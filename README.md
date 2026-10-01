# 🐑 Rancho Ovino — Sistema de Gestión Ganadera

Sistema web para gestión de ganado ovino con base de datos en tiempo real (Supabase).

## Estructura del proyecto

```
rancho-ovino/
├── index.html          ← Página principal (toda la UI)
├── css/
│   ├── base.css        ← Variables, layout, header, navegación
│   ├── auth.css        ← Pantalla de login y registro
│   └── components.css  ← Tablas, modales, formularios, dashboard
└── js/
    ├── config.js       ← Conexión con Supabase (URL y API key)
    ├── utils.js        ← Funciones compartidas (toast, formato, badges)
    ├── auth.js         ← Login, registro y cierre de sesión
    ├── animales.js     ← CRUD de animales
    ├── reproduccion.js ← CRUD de empadres y partos
    ├── produccion.js   ← CRUD de pesos
    ├── salud.js        ← CRUD de eventos de salud
    ├── ventas.js       ← CRUD de ventas y detalle de ventas
    ├── dashboard.js    ← Gráficas y estadísticas
    ├── realtime.js     ← Suscripciones en tiempo real
    └── app.js          ← Inicialización principal
```

## Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| HTML5 / CSS3 / JavaScript | Frontend sin frameworks |
| [Supabase](https://supabase.com) | Base de datos PostgreSQL en la nube + Auth + Realtime |
| [Chart.js](https://chartjs.org) | Gráficas del dashboard |
| Google Fonts | Tipografías (Playfair Display + Lato) |

## Funcionalidades

- 🔐 **Autenticación** — Login y registro con correo y contraseña (Supabase Auth)
- 🐑 **Animales** — Registro con identificador, sexo, raza, estado, padre y madre
- 🐣 **Reproducción** — Empadres con cálculo automático de parto estimado (5 meses)
- ⚖️ **Producción** — Registro de pesos por animal y fecha
- 💉 **Salud** — Vacunas, enfermedades, tratamientos y desparasitaciones
- 💰 **Ventas** — Registro de ventas con cliente y total
- 🧾 **Detalle de ventas** — Animales incluidos en cada venta con precio y peso
- 📊 **Dashboard** — Estadísticas generales y 4 gráficas en tiempo real
- ⚡ **Tiempo real** — Todos los cambios se reflejan automáticamente en todos los dispositivos conectados

## Cómo ejecutar localmente

1. Clona o descarga este repositorio
2. Abre la carpeta con VS Code y usa Live Server, o sirve el sitio en `localhost`.

> **Nota:** La PWA y el service worker no funcionan desde `file://`. Para instalarla en celulares,
> publícala en un origen HTTPS (GitHub Pages, por ejemplo); `localhost` también es seguro para probar.

## Instalar como aplicación (PWA)

- En Android/Chrome, abre el sitio publicado por HTTPS y usa **Instalar aplicación** o **Agregar a pantalla principal**.
- En iPhone/iPad, abre el sitio en Safari, toca **Compartir** y elige **Agregar a pantalla de inicio**.
- La primera visita debe tener conexión para descargar la aplicación y sus recursos. Después se conserva una copia local de la interfaz y algunas bibliotecas.
- La base de datos, el inicio de sesión, los gráficos externos y las operaciones de lectura/escritura siguen requiriendo Internet. Los cambios no se guardan para sincronizar más tarde cuando se está sin conexión.

## Publicar en GitHub Pages

1. Sube la carpeta completa a un repositorio de GitHub
2. Ve a **Settings → Pages**
3. En *Branch* selecciona `main` y carpeta `/root`
4. Guarda — en 2 minutos tendrás tu link público

## Base de datos (Supabase)

El esquema SQL completo está en `database/schema.sql`.  
Para compartir el proyecto sin dar acceso a tu cuenta, exporta el esquema y
el receptor crea su propio proyecto gratuito en [supabase.com](https://supabase.com).

### Seguridad y mantenimiento de una instalación existente

Antes de ejecutar cambios en la base remota, crea una copia de seguridad desde las herramientas de Supabase (la disponibilidad de copias automáticas depende del plan). Prueba la restauración o conserva una exportación descargada antes de actualizar.

En Supabase → **SQL Editor**, ejecuta:

1. `database/security_hardening.sql` para quitar acceso a `anon` y permitir el acceso de la aplicación solo a usuarios autenticados.
2. `database/performance_indexes.sql` para crear índices usados por las consultas y relaciones más frecuentes.

`database/schema_update.sql` también incluye estos cambios para instalaciones que aplican ese script completo. No ejecutes `schema.sql` sobre una base existente: contiene instrucciones de creación inicial.

3. En Supabase → **Authentication → Settings**, desactiva el registro público de usuarios (“Allow new users to sign up”). La página ya no ofrece el formulario de registro; hasta desactivar esta opción, alguien aún podría crear una cuenta directamente con la API de Supabase. Autoriza o invita a las cuentas desde el panel de Supabase; nunca incluyas la clave `service_role` en la página web.

**Importante:** el esquema actual representa un solo rancho compartido. Toda cuenta autenticada puede ver y modificar sus datos. Esta configuración restringe quién puede iniciar sesión, pero todavía no aísla los datos por rancho o por rol. La migración tampoco configura respaldos en Supabase: deben activarse y comprobarse desde el proyecto y el plan correspondientes.

Las listas recuperan los resultados mediante páginas de 500 filas para evitar que el límite de una sola respuesta de la API oculte parte del historial.

## Modificar la conexión

Edita el archivo `js/config.js`:

```js
const SUPABASE_URL = 'https://TU-PROYECTO.supabase.co';
const SUPABASE_KEY = 'eyJ...tu-anon-key...';
```
