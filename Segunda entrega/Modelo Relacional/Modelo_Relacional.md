# Modelo Relacional Normalizado (3FN)

**Proyecto:** Plataforma de Gestión de Alquiler de Vehículos  
**Estudiante:** Erick Santiago Rincon Rojas  
**Código:** 01251151002

Gráfico del modelo relacional en tercera forma normal. El proceso de normalización está en [`Informe_Normalizacion.md`](Informe_Normalizacion.md).

```mermaid
erDiagram
  MEMBRESIA |o--o{ USUARIO : "se suscribe a"
  USUARIO ||--o| USUARIO_PARTICULAR : "es"
  USUARIO ||--o| USUARIO_EMPRESARIAL : "es"
  USUARIO ||--o{ USUARIO_TELEFONO : "tiene"
  MEMBRESIA ||--o{ MEMBRESIA_BENEFICIO : "incluye"
  TARIFA ||--o{ VEHICULO : "aplica a"
  SUCURSAL ||--o{ VEHICULO : "alberga"
  VEHICULO ||--o{ VEHICULO_CARACTERISTICA : "posee"
  VEHICULO ||--o| VEHICULO_ELECTRICO : "es"
  VEHICULO_ELECTRICO ||--o{ VEHICULO_CONECTOR : "admite"
  USUARIO ||--o{ RESERVA : "realiza"
  VEHICULO ||--o{ RESERVA : "es reservado en"
  SUCURSAL ||--o{ RESERVA : "origen"
  SUCURSAL ||--o{ RESERVA : "destino"
  RESERVA ||--o| CONTRATO : "genera"
  CONTRATO ||--o{ INSPECCION : "tiene"
  INSPECCION ||--o{ INSPECCION_DANO : "registra"
  CONTRATO ||--o{ PAGO : "genera"
  SUCURSAL {
    int idSucursal PK
    varchar nombre
    varchar ciudad
    varchar direccion
  }
  TARIFA {
    int idTarifa PK
    decimal precioPorHora
    decimal precioPorDia
    decimal precioPorKm
  }
  MEMBRESIA {
    int idMembresia PK
    varchar nombre
    decimal descuentoPorcentaje
  }
  MEMBRESIA_BENEFICIO {
    int idMembresia PK, FK
    varchar beneficio PK
  }
  USUARIO {
    int idUsuario PK
    varchar nombres
    varchar apellidos
    varchar correo UK
    varchar tipoUsuario
    int idMembresia FK
  }
  USUARIO_TELEFONO {
    int idUsuario PK, FK
    varchar telefono PK
  }
  USUARIO_PARTICULAR {
    int idUsuario PK, FK
    varchar documentoIdentidad UK
  }
  USUARIO_EMPRESARIAL {
    int idUsuario PK, FK
    varchar NIT UK
    varchar razonSocial
    decimal limiteCredito
  }
  VEHICULO {
    varchar placa PK
    varchar marca
    varchar modelo
    varchar tipoVehiculo
    varchar estado
    int idTarifa FK
    int idSucursal FK
  }
  VEHICULO_CARACTERISTICA {
    varchar placa PK, FK
    varchar caracteristica PK
  }
  VEHICULO_ELECTRICO {
    varchar placa PK, FK
    int autonomiaKm
    decimal nivelCargaSOC
  }
  VEHICULO_CONECTOR {
    varchar placa PK, FK
    varchar conectorCarga PK
  }
  RESERVA {
    int idReserva PK
    datetime fechaInicio
    datetime fechaFin
    varchar estadoReserva
    int idUsuario FK
    varchar placa FK
    int idSucursalOrigen FK
    int idSucursalDestino FK
  }
  CONTRATO {
    int idReserva PK, FK
    varchar numeroContrato UK
    date fechaFirma
    decimal depositoGarantia
  }
  INSPECCION {
    int idReserva PK, FK
    int idInspeccion PK
    varchar tipoInspeccion
    int kilometraje
  }
  INSPECCION_DANO {
    int idReserva PK, FK
    int idInspeccion PK, FK
    varchar danoReportado PK
  }
  PAGO {
    int idPago PK
    int idReserva FK
    decimal monto
    date fecha
    varchar metodoPago
  }
```

## Convenciones

- **PK:** llave primaria. **FK:** llave foránea. **UK:** llave alterna (valor único).
- `||` exactamente uno, `o|` cero o uno, `o{` cero o muchos.
- `USUARIO.idMembresia` admite valor nulo, porque un usuario puede no tener membresía.
- `RESERVA` tiene dos llaves foráneas a `SUCURSAL` (`idSucursalOrigen` e `idSucursalDestino`), por eso aparecen dos líneas entre ambas tablas.
- `INSPECCION_DANO` tiene llave foránea compuesta `(idReserva, idInspeccion)` hacia `INSPECCION`.
- La especialización de `USUARIO` (total y disjunta) y la de `VEHICULO` (parcial y disjunta) se representan con las relaciones `es`.
