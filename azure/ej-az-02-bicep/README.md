# ☁️ AZ-01 — Storage Account + Key Vault con Azure Resource Manager (ARM)

**Módulo:** 4 — Aprovisionamiento con IaC y Automatización  
**Herramienta:** Azure Resource Manager (ARM)  
**Tiempo estimado:** 15 minutos  
**Nivel:** Intermedio

---

## 🎯 Objetivo

Desplegar recursos de almacenamiento y seguridad en Azure utilizando una plantilla ARM en formato JSON. Al finalizar este ejercicio habrás creado:

- ✅ Una **Storage Account** de propósito general v2
- ✅ Un **Key Vault** para gestión de secretos

---

## 📋 Prerrequisitos

- Azure CLI instalado y autenticado (`az login`)
- Una suscripción de Azure activa con rol `Contributor`
- Resource Group ya creado (cada alumno debe usar su propio RG)

```bash
# Verificar autenticación
az account show

# Listar suscripciones disponibles
az account list --output table
```

---

## 📁 Archivos del Ejercicio

| Archivo | Descripción |
|---------|-------------|
| `main.bicep` | Plantilla Bicep principal |
| `main.bicepparam` | Archivo de parámetros para el despliegue |

---

## 🚀 Pasos del Ejercicio

### Paso 1 — Verificar el Resource Group

El Resource Group debe existir **antes** del despliegue. Cada alumno debe usar su propio RG (ej. `rg-alumno1-lab`):

```bash
az group show --name <tu-resource-group>
```

### Paso 2 — Revisar la plantilla Bicep

Abre `main.bicep` y observa las secciones principales:

```bicep
param ...
var ...
resource ...
output ...
```

> 💡 En Bicep, las plantillas son declarativas y usan sintaxis más compacta que ARM JSON. Las dependencias se resuelven automáticamente mediante referencias entre recursos.

### Paso 3 — Editar los parámetros

Abre `main.bicepparam` y reemplaza `tu-nombre` con un sufijo único para evitar conflictos con otros alumnos:

```bicepparam
param environmentName string = 'lab'
param location string = 'eastus2'
param storageAccountSku string = 'Standard_LRS'
param uniqueSuffix string = 'tu-nombre'
```


### Paso 4 — Validar la plantilla

```bash
az deployment group validate \
  --resource-group <tu-resource-group> \
  --template-file main.bicep \
  --parameters @main.bicepparam
```

Si la validación es exitosa, recibirás un JSON con `"provisioningState": "Succeeded"`.

### Paso 5 — Previsualizar cambios con what-if

El comando `what-if` muestra qué recursos se crearán, modificarán o eliminarán **sin aplicar ningún cambio**:

```bash
az deployment group what-if \
  --resource-group <tu-resource-group> \
  --template-file main.bicep \
  --parameters @main.bicepparam
```

Analiza la salida:
- `+ Create` → Recurso nuevo
- `~ Modify` → Recurso que será modificado
- `- Delete` → Recurso que será eliminado

### Paso 6 — Desplegar la plantilla

```bash
az deployment group create \
  --name deploy-native-iac-01 \
  --resource-group <tu-resource-group> \
  --template-file main.bicep \
  --parameters @main.bicepparam
```

El despliegue tarda aproximadamente **3-5 minutos**.

### Paso 7 — Monitorear el despliegue

```bash
# Ver el estado del despliegue en curso
az deployment group show \
  --name deploy-native-iac-01 \
  --resource-group <tu-resource-group> \
  --query properties.provisioningState

# Listar todas las operaciones del despliegue
az deployment operation group list \
  --name deploy-native-iac-01 \
  --resource-group <tu-resource-group> \
  --query '[*].{Recurso:properties.targetResource.resourceName,Estado:properties.provisioningState}' \
  --output table
```

### Paso 8 — Ver los Outputs

```bash
az deployment group show \
  --name deploy-native-iac-01 \
  --resource-group <tu-resource-group> \
  --query properties.outputs
```

---

## ✅ Verificación

```bash
# Listar todos los recursos en el Resource Group
az resource list \
  --resource-group <tu-resource-group> \
  --query '[*].{Nombre:name,Tipo:type,Estado:provisioningState}' \
  --output table

# Verificar la Storage Account
az storage account show \
  --resource-group <tu-resource-group> \
  --name <nombre-storage-account> \
  --query '{Nombre:name,SKU:sku.name,Estado:provisioningState}'

# Verificar el Key Vault
az keyvault show \
  --resource-group <tu-resource-group> \
  --name <nombre-key-vault> \
  --query '{Nombre:name,Estado:provisioningState}'
```

---

## 🧹 Limpieza

```bash
# Eliminar los recursos desplegados (NO eliminar el Resource Group)
az deployment group delete \
  --name deploy-native-iac-01 \
  --resource-group <tu-resource-group>

echo "✅ Recursos eliminados, pero el Resource Group permanece"
```

> ⚠️ El Resource Group no se elimina porque ya existía antes del ejercicio.

---

## 🔍 Conceptos Clave Practicados

| Concepto | Descripción |
|----------|-------------|
| **Resource Group** | Contenedor lógico de recursos en Azure |
| **ARM Template** | Plantilla JSON declarativa para despliegue en Azure |
| **what-if** | Previsualización de cambios antes de aplicar (equivalente a `terraform plan`) |
| **dependsOn** | Define dependencias explícitas entre recursos |
| **Variables** | Valores calculados internamente en la plantilla |
| **resourceId()** | Función ARM para referenciar el ID de un recurso |
| **Nombres únicos** | Uso de sufijos para evitar conflictos en suscripciones compartidas |
| **Key Vault** | Servicio para gestión segura de claves, secretos y certificados |

---

## 📚 Referencias

- [Estructura de plantillas ARM](https://learn.microsoft.com/es-es/azure/azure-resource-manager/templates/syntax)
- [Funciones de plantilla ARM](https://learn.microsoft.com/es-es/azure/azure-resource-manager/templates/template-functions)
- [az deployment group](https://learn.microsoft.com/es-es/cli/azure/deployment/group)
