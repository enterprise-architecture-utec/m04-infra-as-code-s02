# ☁️ AZ-02 — Storage Account + Key Vault con Bicep

**Módulo:** 4 — Aprovisionamiento con IaC y Automatización
**Herramienta:** Azure Bicep
**Tiempo estimado:** 15 minutos
**Nivel:** Intermedio

---

## 🎯 Objetivo

Desplegar recursos de almacenamiento y seguridad en Azure utilizando una plantilla Bicep. Al finalizar este ejercicio habrás creado:

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

### Paso 3 — Revisar los parámetros

El archivo `main.bicepparam` define los valores que se pasarán a la plantilla Bicep.
Asegúrate de usar un `uniqueSuffix` único para evitar conflictos de nombres en la suscripción.

> Nota: aunque la documentación Bicep muestra un formato `using 'main.bicep'`, esa sintaxis puede no ser compatible con algunas versiones de Azure CLI. Para evitar el error `unrecognized template parameter 'using 'main.bicep'`, use el formato JSON estándar en `main.bicepparam`.

---

## 📦 Ejemplo de parámetros

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environmentName": {
      "value": "lab"
    },
    "location": {
      "value": "eastus2"
    },
    "storageAccountSku": {
      "value": "Standard_LRS"
    },
    "uniqueSuffix": {
      "value": "tu-nombre"
    }
  }
}
```

---

## 🔧 Validar la plantilla

```bash
az deployment group validate \
  --resource-group <tu-resource-group> \
  --template-file main.bicep \
  --parameters @main.bicepparam
```

---

## 🚀 Desplegar la plantilla

```bash
az deployment group create \
  --name deploy-native-iac-02 \
  --resource-group <tu-resource-group> \
  --template-file main.bicep \
  --parameters @main.bicepparam
```

---

## ⚙️ Comandos útiles

```bash
az deployment group what-if \
  --resource-group <tu-resource-group> \
  --template-file main.bicep \
  --parameters @main.bicepparam

az deployment group show \
  --name deploy-native-iac-02 \
  --resource-group <tu-resource-group> \
  --query properties.provisioningState

az deployment operation group list \
  --name deploy-native-iac-02 \
  --resource-group <tu-resource-group> \
  --query '[*].{Nombre:properties.targetResource.resourceName,Estado:properties.provisioningState}' \
  --output table
```

---

## ✅ Verificación

```bash
az resource list \
  --resource-group <tu-resource-group> \
  --query '[*].{Nombre:name,Tipo:type,Estado:provisioningState}' \
  --output table
```

---

## 🧹 Limpieza

```bash
az deployment group delete \
  --name deploy-native-iac-02 \
  --resource-group <tu-resource-group>
```

> ⚠️ Esto elimina el despliegue, pero no borra el Resource Group.

---

## 📌 Notas

- El archivo `main.bicepparam` debe ser un archivo de parámetros JSON válido.
- Si recibes un error de parámetros no reconocidos, revisa que el valor `uniqueSuffix` esté presente y que no estés usando un archivo de parámetros en un formato incorrecto.
