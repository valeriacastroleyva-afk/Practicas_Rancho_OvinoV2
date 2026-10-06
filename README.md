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

- 🔐 **Autenticación** — Inicio de sesión y registro directo; las cuentas nuevas empiezan como Productor y un administrador existente puede cambiar su rol
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
- La primera visita y el primer inicio de sesión deben hacerse con conexión. La app conserva en el navegador del dispositivo el perfil y el último conjunto de datos descargado.
- Sin conexión se pueden consultar esos datos y guardar nuevos animales, empadres, pesajes, eventos de salud y razas. Los registros quedan en una cola local y se sincronizan al volver la conexión; si Supabase detecta un duplicado o una restricción, la app conserva el grupo y lo marca para revisión en vez de sobrescribir datos.
- Editar/eliminar registros existentes, registrar ventas, iniciar sesión por primera vez y las operaciones de Supabase requieren Internet. No hay sincronización de datos entre dispositivos mientras estén desconectados.
- Los datos cacheados y cambios pendientes permanecen en el almacenamiento del navegador de ese dispositivo. Usa bloqueo de pantalla y no borres los datos del sitio hasta que la cola pendiente se haya sincronizado.
- Antes de trabajar sin conexión, inicia sesión y deja que carguen los registros con Internet. Al recuperar señal, mantén la app abierta o ábrela de nuevo para iniciar la sincronización automática; revisa el aviso superior si aparece un conflicto.

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

Si al guardar un animal aparece `violates check constraint "animales_estado_check"`, ejecuta `database/fix_animales_estado_constraint.sql` en Supabase → **SQL Editor**. La actualización acepta `activo`, `vendido` y `muerto` sin importar mayúsculas, para ser compatible con versiones anteriores de la aplicación.

3. Para habilitar el registro directo actual, en Supabase → **Authentication → Settings**, activa **Allow new users to sign up**. Las nuevas cuentas se crean con rol Productor; otros roles deben asignarse manualmente por un administrador desde Supabase. Si la confirmación de correo está activa, cada persona debe confirmar su dirección antes de iniciar sesión. No se guarda la contraseña en la base de datos de la aplicación.

#### Solicitudes de acceso anteriores

Estos pasos solo se necesitan para administrar solicitudes o invitaciones creadas con el flujo anterior; el registro directo actual no depende de la función `registration-request`.

1. En Supabase → **SQL Editor**, ejecuta `database/registration_approval.sql`. Esto crea o actualiza la tabla de solicitudes, restringe su lectura a administradores, impide envíos directos a la tabla y habilita Realtime para avisos dentro de la aplicación. Si ya ejecutaste una versión anterior, vuelve a ejecutar esta migración.
2. Ambas funciones usan las claves administrativas protegidas del entorno Edge Functions. Si Supabase no expone `SUPABASE_SERVICE_ROLE_KEY`, configura `RANCHO_SUPABASE_ADMIN_KEY` con la clave `service_role`. Nunca pongas esa clave en el HTML.
3. Desde la carpeta del proyecto, enlaza el proyecto Supabase correcto y despliega la función protegida:

   ```powershell
   supabase login
   supabase link --project-ref TU_PROJECT_REF
   supabase functions deploy registration-request --project-ref TU_PROJECT_REF
   supabase functions deploy manage-registration --project-ref TU_PROJECT_REF
   ```

4. Publica `index.html` y `service-worker.js`. Para recibir el aviso en tiempo real, el administrador debe tener sesión iniciada y la aplicación abierta; también se actualiza la lista periódicamente mientras la sesión está activa.

Los administradores deben tener `rol = 'admin'` en `public.usuarios`. Los usuarios no pueden asignarse el rol `admin`; los roles se cambian manualmente desde Supabase por un administrador.

Para hacer administrador al perfil llamado exactamente **Usuario**, ejecuta `database/configure_admin_profile.sql` desde Supabase → **SQL Editor**. El script actualiza la base únicamente si encuentra exactamente una cuenta con ese nombre; si hay cero o varias, se detiene sin cambiar cuentas.

Para restablecer contraseñas, la persona usa **¿Olvidaste tu contraseña?** en la pantalla de acceso. En Supabase → **Authentication → URL Configuration**, establece como **Site URL** la dirección HTTPS publicada de la aplicación y agrega la misma dirección a **Redirect URLs**. Tras publicar la versión actualizada, el enlace del correo abre el formulario para definir una contraseña nueva; no inicia la aplicación hasta validar y guardar esa contraseña.

Tras aceptar la invitación, la persona puede iniciar sesión. Si necesita establecer o cambiar su contraseña, puede usar **¿Olvidaste tu contraseña?** en la pantalla de acceso.

**Importante:** el esquema actual representa un solo rancho compartido. Con el registro público activado, cualquier persona que cree y confirme una cuenta puede ver y modificar los datos; todavía no hay aislamiento por usuario, rancho o rol. La migración tampoco configura respaldos en Supabase: deben activarse y comprobarse desde el proyecto y el plan correspondientes.

Las listas recuperan los resultados mediante páginas de 500 filas para evitar que el límite de una sola respuesta de la API oculte parte del historial.

## Modificar la conexión

Edita el archivo `js/config.js`:

```js
const SUPABASE_URL = 'https://TU-PROYECTO.supabase.co';
const SUPABASE_KEY = 'eyJ...tu-anon-key...';
```
