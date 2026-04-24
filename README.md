# 🛠️ Ejercicios Guiados — IaC con Herramientas Nativas

**Curso:** Arquitectura de Soluciones Multinube  
**Módulo 4:** Aprovisionamiento con IaC y Automatización  
**Sesión 2:** IaC con Herramientas Nativas  
**Docente:** Aldo Trucios — UTEC Posgrado

---

## 📁 Estructura del Repositorio

```
m04-native-iac-labs/
├── aws/
│   ├── ej-aws-01-cloudformation/      # VPC + EC2 + S3
│   ├── ej-aws-02-cloudformation/      # RDS MySQL + Secrets Manager
│   └── ej-aws-03-cloudformation/      # Lambda + API Gateway + DynamoDB
├── azure/
│   ├── ej-az-01-arm/                  # VNet + Storage Account (ARM)
│   ├── ej-az-02-bicep/                # App Service + Storage Account (Bicep)
│   ├── ej-az-03-arm/                  # Container Instance + Key Vault (ARM)
│   ├── ej-az-04-arm/                  # Azure SQL + App Service (ARM)
│   ├── ej-az-05-bicep/                # VNet + VM Linux (Bicep)
│   └── ej-az-06-bicep/                # AKS + ACR con Módulos Bicep
│       └── modules/
│           └── network.bicep
└── README.md
```

---

## ⏱️ Distribución de Tiempo

### ☁️ AWS CloudFormation

| # | Ejercicio | Servicios | Tiempo |
|---|-----------|-----------|--------|
| AWS-01 | [VPC + EC2 + S3](aws/ej-aws-01-cloudformation/README.md) | VPC, EC2, S3 | 25 min |
| AWS-02 | [RDS MySQL + Secrets Manager](aws/ej-aws-02-cloudformation/README.md) | RDS, Secrets Manager | 30 min |
| AWS-03 | [Lambda + API Gateway + DynamoDB](aws/ej-aws-03-cloudformation/README.md) | Lambda, API GW, DynamoDB | 35 min |
| | **Subtotal AWS** | | **~90 min** |

### ☁️ Azure Resource Manager (ARM)

| # | Ejercicio | Servicios | Tiempo |
|---|-----------|-----------|--------|
| AZ-01 | [VNet + Storage Account](azure/ej-az-01-arm/README.md) | VNet, NSG, Storage | 25 min |
| AZ-03 | [Container Instance + Key Vault](azure/ej-az-03-arm/README.md) | ACI, Key Vault | 30 min |
| AZ-04 | [Azure SQL + App Service](azure/ej-az-04-arm/README.md) | SQL Server, SQL DB, Web App | 30 min |
| | **Subtotal ARM** | | **~85 min** |

### ☁️ Azure Bicep

| # | Ejercicio | Servicios | Tiempo |
|---|-----------|-----------|--------|
| AZ-02 | [App Service + Storage Account](azure/ej-az-02-bicep/README.md) | App Service, Storage | 25 min |
| AZ-05 | [VNet + VM Linux](azure/ej-az-05-bicep/README.md) | VNet, VM, NIC, IP Pública | 30 min |
| AZ-06 | [AKS + ACR con Módulos Bicep](azure/ej-az-06-bicep/README.md) | AKS, ACR, RBAC, Módulos | 35 min |
| | **Subtotal Bicep** | | **~90 min** |

| | **TOTAL** | | **~4 horas 25 min** |

---

## ⚙️ Requisitos Previos

| Herramienta | Versión mínima | Instalación |
|-------------|----------------|-------------|
| AWS CLI | >= 2.13 | https://aws.amazon.com/cli/ |
| Azure CLI | >= 2.50 | https://learn.microsoft.com/cli/azure/install-azure-cli |
| Bicep CLI | >= 0.24 | `az bicep install` |
| kubectl | >= 1.28 | https://kubernetes.io/docs/tasks/tools/ (solo AZ-06) |
| Cuenta AWS | — | Permisos: CloudFormation, EC2, S3, RDS, Lambda, API GW, DynamoDB, IAM |
| Cuenta Azure | — | Rol `Contributor` + permisos de asignación de roles en la suscripción |

---

## 🔐 Autenticación

### AWS

```bash
aws configure
# Ingresa: Access Key ID, Secret Access Key, Region (us-east-1), Output (json)

# Verificar identidad
aws sts get-caller-identity
```

### Azure

```bash
az login
az account set --subscription "<ID_DE_TU_SUSCRIPCION>"

# Verificar suscripción activa
az account show --query '{Nombre:name,ID:id,Estado:state}' --output json
```

---

## 🧹 Limpieza de Recursos

> ⚠️ **Importante:** Siempre elimina los recursos al finalizar cada laboratorio para evitar costos innecesarios.

### AWS — Eliminar Stack

```bash
aws cloudformation delete-stack --stack-name <nombre-del-stack>
aws cloudformation wait stack-delete-complete --stack-name <nombre-del-stack>
```

### Azure — Eliminar Resource Group

```bash
az group delete --name <nombre-resource-group> --yes --no-wait
```

---

## 📚 Referencias

- [AWS CloudFormation Docs](https://docs.aws.amazon.com/cloudformation/)
- [AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/)
- [Azure Resource Manager Docs](https://learn.microsoft.com/es-es/azure/azure-resource-manager/)
- [Azure Bicep Docs](https://learn.microsoft.com/es-es/azure/azure-resource-manager/bicep/)
- [Bicep Playground (Bicep ↔ ARM)](https://bicepdemo.z22.web.core.windows.net/)

---

> 💡 **Consejo:** Para cada ejercicio, sigue siempre el flujo: **validar → previsualizar → desplegar → verificar → limpiar**. Este ciclo refleja las mejores prácticas de IaC en entornos reales.
