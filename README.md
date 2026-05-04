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
│   └── ej-aws-01-cloudformation/      # VPC + EC2 + S3
└── azure/
    ├── ej-az-01-arm/                  # VNet + Storage Account (ARM)
    └── ej-az-02-bicep/                # Storage Account + Key Vault (Bicep)
```

---

## 📌 Ejercicios disponibles

| # | Ejercicio | Carpeta | Servicios | Tiempo |
|---|-----------|---------|-----------|--------|
| AWS-01 | [VPC + Subnet pública + IGW + SG + S3](aws/ej-aws-01-cloudformation/README.md) | `aws/ej-aws-01-cloudformation/` | VPC, Subnet pública, IGW, SG, S3 | 20 min |
| AZ-01 | [Storage Account + Key Vault](azure/ej-az-01-arm/README.md) | `azure/ej-az-01-arm/` | Storage Account, Key Vault | 15 min |
| AZ-02 | [Storage Account + Key Vault](azure/ej-az-02-bicep/README.md) | `azure/ej-az-02-bicep/` | Storage Account, Key Vault | 15 min |

| | **TOTAL** | | | **~50 min** |

---

## ⚙️ Requisitos Previos

| Herramienta | Versión mínima | Instalación |
|-------------|----------------|-------------|
| AWS CLI | >= 2.13 | https://aws.amazon.com/cli/ |
| Azure CLI | >= 2.50 | https://learn.microsoft.com/cli/azure/install-azure-cli |
| Bicep CLI | >= 0.24 | `az bicep install` |

---

## 🔐 Autenticación

### AWS

```bash
aws configure
# Ingresa: Access Key ID, Secret Access Key, Region, Output (json)

aws sts get-caller-identity
```

### Azure

```bash
az login
az account set --subscription "<ID_DE_TU_SUSCRIPCION>"

az account show --query '{Nombre:name,ID:id,Estado:state}' --output json
```

---

## 🧹 Limpieza de Recursos

> ⚠️ Siempre elimina los recursos al finalizar cada ejercicio para evitar costos innecesarios.

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
- [Azure Resource Manager Docs](https://learn.microsoft.com/es-es/azure/azure-resource-manager/)
- [Azure Bicep Docs](https://learn.microsoft.com/es-es/azure/azure-resource-manager/bicep/)

---

> 💡 Consejo: sigue siempre el ciclo de IaC: **validar → previsualizar → desplegar → verificar → limpiar**.
