# 🧹 EasyPanel Clean Deploy Checklist

## ✅ PRÉ-DEPLOY CHECKLIST

### 1. 🛑 **STOP tudo**
- [ ] Todos os serviços parados
- [ ] Nenhum container rodando

### 2. 🗑️ **DELETE volumes**
- [ ] postgres_data (OBRIGATÓRIO)
- [ ] minio_data
- [ ] Qualquer volume do AppFlowy

### 3. 🔄 **CLEAR cache**
- [ ] Prune containers se disponível
- [ ] Ou delete projeto inteiro

### 4. 📄 **PREPARE arquivos**
- [ ] docker-compose.yml sem nginx
- [ ] .env.easypanel.fixed copiado
- [ ] Domínio aponta para appflowy_cloud:8000

## 🚀 **DEPLOY STEPS**

### 1. **Environment Variables**
Copie EXATAMENTE do `.env.easypanel.fixed`:
```bash
POSTGRES_USER=postgres
POSTGRES_DB=postgres
POSTGRES_PASSWORD=0c24791672e502b068e0cf682bcc5fb1
POSTGRES_INITDB_ROOT_PASSWORD=0c24791672e502b068e0cf682bcc5fb1
GOTRUE_JWT_SECRET=FOc09wLUzG44WjrllGgkoGbT6tQO16OMQ7E8cxRfZ4VdgZjndOdLIH5i7u2w9VDn
GOTRUE_ADMIN_EMAIL=admin@yourdomain.com
GOTRUE_ADMIN_PASSWORD=QWeS1EVqzuiV+MZ6MLazkf9le3qwN3H8uIvEd+O09nY=
GOTRUE_SMTP_HOST=localhost
GOTRUE_SMTP_PORT=587
GOTRUE_SMTP_USER=noreply@localhost
GOTRUE_SMTP_PASS=password
# ... e todas as outras
```

### 2. **Deploy**
- [ ] Upload docker-compose.yml
- [ ] Paste environment variables
- [ ] Set domain to appflowy_cloud:8000
- [ ] Deploy

### 3. **Monitor**
Aguarde na seguinte ordem:
1. ✅ PostgreSQL (pode levar 2-3 min)
2. ✅ Redis (rápido)
3. ✅ MinIO (rápido) 
4. ✅ GoTrue (após postgres)
5. ✅ AppFlowy Cloud (após todos)

## 🔍 **TROUBLESHOOTING**

### Se PostgreSQL falhar:
- Verifique se volume foi REALMENTE deletado
- Use PostgreSQL 15 (pg15)
- Senha sem caracteres especiais

### Se GoTrue falhar:
- SMTP deve ter valores (não vazio)
- JWT_SECRET deve ter 32+ chars

### Se Worker falhar:
- Todas as variáveis WORKER devem existir
- Não podem estar vazias

## 🎯 **SUCESSO ESPERADO**

Logs que indicam sucesso:
```
postgres-1: database system is ready to accept connections
gotrue-1: listening on port 9999
appflowy_cloud-1: Server listening on 0.0.0.0:8000
```

## ⚠️ **Red Flags**

Erros que indicam limpeza incompleta:
- "role postgres does not exist" = volume não foi deletado
- "parsing empty string" = variáveis não carregaram
- "version incompatible" = dados antigos ainda lá