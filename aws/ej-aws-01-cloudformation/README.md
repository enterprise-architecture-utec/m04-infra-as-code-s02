# ☁️ AWS-01 — VPC + Subnet Pública + IGW + SG + S3 con AWS CloudFormation

**Módulo:** 4 — Aprovisionamiento con IaC y Automatización  
**Herramienta:** AWS CloudFormation  
**Tiempo estimado:** 20 minutos  
**Nivel:** Intermedio

---

## 🎯 Objetivo

Aprovisionar una infraestructura básica en AWS utilizando una plantilla CloudFormation en YAML. Al finalizar este ejercicio habrás creado:

- ✅ Una **VPC** con CIDR `10.{StudentId}.0.0/16` (parametrizable)
- ✅ Una **Subnet pública** con CIDR `10.{StudentId}.1.0/24`
- ✅ Un **Internet Gateway** adjunto a la VPC
- ✅ Una **tabla de rutas** con ruta a Internet
- ✅ Un **Security Group** con acceso SSH (puerto 22) y HTTP (puerto 80)
- ✅ Un **bucket S3** con nombre único

---

## 📋 Prerrequisitos

- AWS CLI configurado con credenciales válidas (`aws configure`)
- Permisos IAM para: `cloudformation:*`, `ec2:*`, `s3:*`
- Región: **us-west-2** (para evitar límites de VPC)

```bash
# Verificar autenticación
aws sts get-caller-identity

# Configurar región por defecto (Considera la región asignada)
aws configure set region us-west-2
```

---

## 📁 Archivos del Ejercicio

| Archivo | Descripción |
|---------|-------------|
| `template.yaml` | Plantilla CloudFormation principal |
| `parameters.json` | Archivo de parámetros para el despliegue |

---

## 🚀 Pasos del Ejercicio

### Paso 1 — Revisar la plantilla

Abre `template.yaml` y observa las secciones principales:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: ...
Parameters: ...     # Variables de entrada
Resources: ...      # Recursos a crear (OBLIGATORIO)
Outputs: ...        # Valores exportados al finalizar
```

> 💡 La sección `Resources` es la **única obligatoria** en una plantilla CloudFormation.

### Paso 2 — Editar los parámetros

Abre `parameters.json` y reemplaza `tu-nombre` con un sufijo único para evitar conflictos con otros alumnos (ej. tu-nombre-apellido), y asigna un `StudentId` único (número entre 0-255) para definir el segmento de red:

```json
[
  {
    "ParameterKey": "EnvironmentName",
    "ParameterValue": "lab"
  },
  {
    "ParameterKey": "UniqueSuffix",
    "ParameterValue": "tu-nombre"
  },
  {
    "ParameterKey": "StudentId",
    "ParameterValue": "1"
  }
]
```

### Paso 3 — Validar la plantilla

Antes de desplegar, valida que la plantilla no tenga errores de sintaxis:

```bash
aws cloudformation validate-template \
  --template-body file://template.yaml \
  --region us-west-2
```

Si el comando retorna el objeto con los parámetros, la plantilla es válida.

### Paso 4 — Previsualizar cambios (opcional)

Crea un Change Set para ver qué recursos se crearán sin aplicarlos aún:

```bash
aws cloudformation create-change-set \
  --stack-name lab-native-iac-tu-nombre \
  --change-set-name preview-inicial \
  --template-body file://template.yaml \
  --parameters file://parameters.json \
  --change-set-type CREATE \
  --region us-west-2

# Ver los cambios planeados
aws cloudformation describe-change-set \
  --stack-name lab-native-iac-tu-nombre \
  --change-set-name preview-inicial \
  --query 'Changes[*].ResourceChange.{Accion:Action,Tipo:ResourceType,ID:LogicalResourceId}' \
  --output table \
  --region us-west-2
```

### Paso 5 — Desplegar el Stack

```bash
aws cloudformation create-stack \
  --stack-name lab-native-iac-tu-nombre \
  --template-body file://template.yaml \
  --parameters file://parameters.json \
  --capabilities CAPABILITY_NAMED_IAM \
  --region us-west-2
```

### Paso 6 — Monitorear el despliegue

```bash
# Esperar a que el stack esté completamente creado
aws cloudformation wait stack-create-complete \
  --stack-name lab-native-iac-tu-nombre \
  --region us-west-2

# Ver el estado actual del stack
aws cloudformation describe-stacks \
  --stack-name lab-native-iac-tu-nombre \
  --query 'Stacks[0].StackStatus' \
  --region us-west-2
```

También puedes monitorear en tiempo real con:

```bash
aws cloudformation describe-stack-events \
  --stack-name lab-native-iac-tu-nombre \
  --query 'StackEvents[*].{Recurso:LogicalResourceId,Estado:ResourceStatus,Razon:ResourceStatusReason}' \
  --output table \
  --region us-west-2
```

### Paso 7 — Ver los Outputs

Una vez creado el stack, visualiza los valores exportados:

```bash
aws cloudformation describe-stacks \
  --stack-name lab-native-iac-tu-nombre \
  --query 'Stacks[0].Outputs[*].{Clave:OutputKey,Valor:OutputValue,Descripcion:Description}' \
  --output table \
  --region us-west-2
```

Deberías ver el ID de la VPC, ID de la Subnet y el nombre del bucket S3.

---

## ✅ Verificación

```bash
# Verificar que la VPC fue creada
aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=lab-VPC-tu-nombre" \
  --query 'Vpcs[0].VpcId' \
  --region us-west-2

# Verificar que la Subnet fue creada
aws ec2 describe-subnets \
  --filters "Name=tag:Name,Values=lab-Public-Subnet-tu-nombre" \
  --query 'Subnets[0].SubnetId' \
  --region us-west-2

# Verificar que el bucket S3 fue creado
aws s3 ls | grep lab-native-iac-tu-nombre
```

---

## 🧹 Limpieza

```bash
# Eliminar el Stack (elimina TODOS los recursos creados)
aws cloudformation delete-stack \
  --stack-name lab-native-iac-tu-nombre \
  --region us-west-2

# Esperar a que la eliminación termine
aws cloudformation wait stack-delete-complete \
  --stack-name lab-native-iac-tu-nombre \
  --region us-west-2

echo "✅ Stack eliminado correctamente"
```

> ⚠️ El bucket S3 debe estar **vacío** para que CloudFormation pueda eliminarlo. Si tiene objetos, deberás vaciarlo manualmente primero.

---

## 🔍 Conceptos Clave Practicados

| Concepto | Descripción |
|----------|-------------|
| **Stack** | Colección de recursos AWS gestionados como una unidad |
| **Change Set** | Previsualización de cambios antes de aplicarlos |
| **Parameters** | Variables de entrada que parametrizan la plantilla |
| **Outputs** | Valores que el stack exporta al finalizar |
| **Rollback automático** | Si un recurso falla, CloudFormation revierte todo |
| **DependsOn** | Define el orden de creación entre recursos |
| **Nombres únicos** | Uso de sufijos para evitar conflictos en cuentas compartidas |

---

## 📚 Referencias

- [CloudFormation Template Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html)
- [CloudFormation Resource Types](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)
- [AWS CLI CloudFormation Commands](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cloudformation/index.html)
