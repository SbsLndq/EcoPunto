# 🌱 EcoPunto

Aplicación móvil desarrollada con Flutter para facilitar la consulta y reporte de puntos de reciclaje.

EcoPunto permite encontrar puntos de reciclaje, consultar los materiales que reciben y registrar nuevos puntos. La aplicación incorpora autenticación, almacenamiento local y almacenamiento en la nube, permitiendo trabajar temporalmente sin conexión y sincronizar posteriormente la información.

-----> Presentación usada para la sustentación: https://ecopunto-pi.vercel.app/

## 🎯 Problema

La información sobre puntos de reciclaje puede encontrarse dispersa o desactualizada, dificultando que los ciudadanos sepan dónde llevar sus residuos o reporten nuevos lugares.

EcoPunto propone centralizar esta información mediante una aplicación móvil sencilla, accesible y con capacidad de funcionamiento offline.

## 💡 Solución

La aplicación integra:

- Consulta de puntos de reciclaje mediante mapa.
- Búsqueda por nombre, dirección o material.
- Registro de nuevos puntos.
- Autenticación de usuarios.
- Almacenamiento local de reportes.
- Almacenamiento en la nube mediante Cloud Firestore.
- Sincronización de reportes cuando se recupera la conexión.
- Protección de los datos mediante reglas de seguridad.

## 🛠️ Tecnologías

| Tecnología | Uso |
|---|---|
| Flutter | Desarrollo de la aplicación móvil |
| Dart | Lenguaje de programación |
| Firebase Authentication | Registro e inicio de sesión |
| Cloud Firestore | Almacenamiento de reportes |
| SharedPreferences | Almacenamiento local |
| OpenStreetMap | Visualización de mapas |
| flutter_map | Integración del mapa |
| latlong2 | Coordenadas geográficas |
| url_launcher | Apertura de ubicaciones |
| GitHub | Control y publicación del proyecto |

## 🏗️ Arquitectura

EcoPunto utiliza una arquitectura modular basada en separación de responsabilidades.

```text
                         ECO PUNTO
                            │
                     Aplicación Flutter
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
       Screens            Services          Models
          │                 │
          │        ┌────────┼────────┐
          │        │        │        │
          │       Auth   Firestore  Storage
          │        │        │        │
          │        ▼        ▼        ▼
          │     Firebase  Firestore  Local
          │       Auth      ☁️      Storage
          │
          ▼
    Interfaz de usuario
```

### Servicios principales

**Firebase Authentication**

Gestiona el registro e inicio de sesión mediante correo electrónico y contraseña.

**Cloud Firestore**

Almacena los reportes registrados por los usuarios y los relaciona mediante su identificador de autenticación.

**SharedPreferences**

Permite conservar localmente los reportes cuando no existe conexión.

**OpenStreetMap**

Proporciona la visualización de los puntos de reciclaje en el mapa.

## 📡 Funcionamiento Offline-First

Los reportes se guardan inicialmente en el almacenamiento local.

Cada reporte contiene un indicador `synced` que permite identificar si ya fue enviado a la nube.

```text
Crear reporte
     │
     ▼
SharedPreferences
     │
     ▼
synced = false
     │
     ├── Con conexión ──────► Firestore
     │                          │
     │                          ▼
     │                     synced = true
     │
     └── Sin conexión
            │
            ▼
       Permanece local
            │
       Se recupera conexión
            │
            ▼
      Sincronización
            │
            ▼
         Firestore
```

## 🔐 Seguridad

Cloud Firestore utiliza reglas de seguridad para controlar el acceso a los reportes.

Los reportes se relacionan con el `uid` del usuario autenticado.

Las reglas permiten que:

- Los usuarios autenticados creen reportes propios.
- Cada usuario consulte sus propios reportes.
- Cada usuario modifique o elimine sus propios reportes.
- Los usuarios no autenticados no accedan a la colección de reportes.

## 📂 Estructura del proyecto

```text
lib/
├── main.dart
├── firebase_options.dart
│
├── models/
│   └── recycling_point.dart
│
├── screens/
│   ├── login_screen.dart
│   ├── map_screen.dart
│   ├── report_screen.dart
│   └── profile_screen.dart
│
└── services/
    ├── auth_service.dart
    ├── firestore_service.dart
    └── storage_service.dart
```

## ⚙️ Instalación

### Requisitos

- Flutter SDK
- Dart SDK
- Android Studio
- Git
- Cuenta de Firebase

### Clonar el proyecto

```bash
git clone https://github.com/SbsLndq/EcoPunto.git
cd EcoPunto
```

### Instalar dependencias

```bash
flutter pub get
```

### Ejecutar

Para ejecutar en Chrome:

```bash
flutter run -d chrome
```

Para ejecutar en un dispositivo Android:

```bash
flutter run
```

## 🔥 Configuración de Firebase

El proyecto utiliza Firebase para autenticación y almacenamiento de información.

Servicios configurados:

- Firebase Authentication
- Cloud Firestore

La configuración de Firebase para las plataformas soportadas se encuentra en:

```text
lib/firebase_options.dart
```

El proveedor de autenticación utilizado es:

```text
Correo electrónico / contraseña
```

## 🧪 Pruebas realizadas

Se realizaron pruebas funcionales de:

- Registro de usuarios.
- Inicio de sesión.
- Visualización y búsqueda de puntos de reciclaje.
- Registro de nuevos puntos.
- Guardado local de reportes.
- Guardado de reportes en Cloud Firestore.
- Asociación de reportes con usuarios autenticados.
- Funcionamiento sin conexión.
- Sincronización posterior con Firestore.
- Aplicación de reglas de seguridad.

La calidad del código fue validada mediante:

```bash
flutter analyze
```

Resultado:

```text
No issues found!
```

## 🚀 Mejoras futuras

Como posibles líneas de evolución se plantean:

- Geolocalización del usuario.
- Validación de reportes.
- Sistema de puntos y recompensas.
- Notificaciones.
- Panel administrativo.
- Mayor cobertura de pruebas automatizadas.
- Mejoras en la gestión de conflictos durante la sincronización.

Estas funcionalidades quedan fuera del alcance del MVP desarrollado.

## 👨‍💻 Autor

**Sebastian Londoño Quirama**

Proyecto para **Diseño de Aplicaciones Móviles**.

## 📌 Estado

**MVP funcional**

EcoPunto cuenta con autenticación, mapa, reportes, almacenamiento local, Cloud Firestore, reglas de seguridad y sincronización de información.
