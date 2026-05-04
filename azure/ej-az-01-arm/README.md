# ☁️ AZ-01 — Storage Account + Azure Functions con Azure Resource Manager (ARM)

**Módulo:** 4 — Aprovisionamiento con IaC y Automatización  
**Herramienta:** Azure Resource Manager (ARM)  
**Tiempo estimado:** 20 minutos  
**Nivel:** Intermedio

---

## 🎯 Objetivo

Desplegar recursos de almacenamiento y computación serverless en Azure utilizando una plantilla ARM en formato JSON. Al finalizar este ejercicio habrás creado:

- ✅ Una **Storage Account** de propósito general v2
- ✅ Una **Function App** con runtime configurable (Node.js, .NET, Python)
- ✅ Un **App Service Plan** en modo Consumption (serverless)

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
| `azuredeploy.json` | Plantilla ARM principal |
| `azuredeploy.parameters.json` | Archivo de parámetros para el despliegue |

---

## 🚀 Pasos del Ejercicio

### Paso 1 — Verificar el Resource Group

El Resource Group debe existir **antes** del despliegue. Cada alumno debe usar su propio RG (ej. `rg-alumno1-lab`):

```bash
az group show --name <tu-resource-group>
```

### Paso 2 — Revisar la plantilla ARM

Abre `azuredeploy.json` y observa las secciones principales:

```json
{
  "$schema": "...",
  "contentVersion": "1.0.0.0",
  "parameters": { },   // Variables de entrada
  "variables": { },    // Variables internas calculadas
  "resources": [ ],    // Recursos a crear
  "outputs": { }       // Valores exportados
}
```

> 💡 En ARM, los recursos se definen en un **array JSON**. ARM resuelve las dependencias automáticamente mediante `dependsOn`.

### Paso 3 — Editar los parámetros

Abre `azuredeploy.parameters.json` y reemplaza `tu-nombre` con un sufijo único para evitar conflictos con otros alumnos:

```json
{
  "parameters": {
    "uniqueSuffix": {
      "value": "tu-nombre"
    }
  }
}
```

### Paso 4 — Validar la plantilla

```bash
az deployment group validate \
  --resource-group <tu-resource-group> \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json
```

Si la validación es exitosa, recibirás un JSON con `"provisioningState": "Succeeded"`.

### Paso 5 — Previsualizar cambios con what-if

El comando `what-if` muestra qué recursos se crearán, modificarán o eliminarán **sin aplicar ningún cambio**:

```bash
az deployment group what-if \
  --resource-group <tu-resource-group> \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json
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
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json
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

# Verificar la Function App
az functionapp show \
  --resource-group <tu-resource-group> \
  --name <nombre-function-app> \
  --query '{Nombre:name,Estado:state,Runtime:siteConfig.appSettings[?name==`FUNCTIONS_WORKER_RUNTIME`].value}'
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
| **Serverless** | Computación sin servidor con Azure Functions y Consumption Plan |

---

## 📚 Referencias

- [Estructura de plantillas ARM](https://learn.microsoft.com/es-es/azure/azure-resource-manager/templates/syntax)
- [Funciones de plantilla ARM](https://learn.microsoft.com/es-es/azure/azure-resource-manager/templates/template-functions)
- [az deployment group](https://learn.microsoft.com/es-es/cli/azure/deployment/group)
