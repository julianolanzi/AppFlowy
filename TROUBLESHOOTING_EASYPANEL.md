# 🚨 Troubleshooting EasyPanel Deploy

## Erro: "dependency failed to start: container is unhealthy"

### 📋 Checklist Rápido:

1. **✅ Copiou o arquivo `.env.easypanel` para `.env`?**
2. **✅ Configurou todas as variáveis de ambiente no EasyPanel?**
3. **✅ Domínio aponta para `appflowy_cloud:8000`?**
4. **✅ Removeu caracteres especiais das senhas?**

### 🔧 Soluções por Problema:

#### **PostgreSQL Unhealthy**
```bash
# Sinais do problema:
- Container postgres fica em "unhealthy"
- Logs mostram erro de autenticação
- Outros serviços dependentes não iniciam

# Soluções:
1. Verificar se POSTGRES_PASSWORD não tem caracteres especiais
2. Usar senha hexadecimal simples: 0c24791672e502b068e0cf682bcc5fb1
3. Verificar se variáveis estão sendo expandidas corretamente
```

#### **GoTrue Unhealthy**
```bash
# Sinais do problema:
- Container gotrue fica em "unhealthy"
- Erro de conexão com banco de dados
- Timeout no healthcheck

# Soluções:
1. Aguardar PostgreSQL ficar totalmente healthy
2. Verificar GOTRUE_DATABASE_URL
3. Verificar se GOTRUE_JWT_SECRET está correto
```

#### **AppFlowy Cloud não inicia**
```bash
# Sinais do problema:
- Container appflowy_cloud falha ao iniciar
- Erro de conexão com dependencies
- Timeout na porta 8000

# Soluções:
1. Verificar se todos os serviços dependentes estão healthy
2. Verificar se porta 8000 está exposta corretamente
3. Verificar logs do container para erro específico
```

### 🔍 Como Debuggar no EasyPanel:

1. **Ver Logs dos Containers:**
   - Vá em "Services" no EasyPanel
   - Clique no container com problema
   - Veja a aba "Logs"

2. **Verificar Status dos Serviços:**
   - Todos devem estar "Running" e "Healthy"
   - Se algum estiver "Unhealthy", foque nele primeiro

3. **Ordem de Inicialização:**
   ```
   1. postgres (deve ficar healthy primeiro)
   2. redis (normalmente inicia rápido)
   3. gotrue (depende do postgres)
   4. appflowy_cloud (depende do gotrue e postgres)
   5. outros serviços (dependem do appflowy_cloud)
   ```

### 🛠️ Comandos Úteis:

```bash
# Verificar se PostgreSQL está respondendo
docker exec -it postgres-container pg_isready -U postgres

# Ver logs detalhados do PostgreSQL
docker logs postgres-container

# Testar conexão manual ao banco
docker exec -it postgres-container psql -U postgres -d postgres
```

### 📞 Quando Pedir Ajuda:

Se depois de seguir este guia ainda tiver problemas, forneça:

1. **Logs específicos** do container que está falhando
2. **Screenshot** do status dos serviços no EasyPanel
3. **Variáveis de ambiente** que você configurou (sem senhas)
4. **Mensagem de erro completa**

### 🎯 Configuração que Funciona:

```env
# PostgreSQL simples e confiável
POSTGRES_USER=postgres
POSTGRES_DB=postgres
POSTGRES_PASSWORD=0c24791672e502b068e0cf682bcc5fb1
POSTGRES_HOST=postgres
POSTGRES_PORT=5432

# JWT simples mas seguro
GOTRUE_JWT_SECRET=FOc09wLUzG44WjrllGgkoGbT6tQO16OMQ7E8cxRfZ4VdgZjndOdLIH5i7u2w9VDn

# Domínio correto
FQDN=english-appflowy.g9awyq.easypanel.host
```

Esta configuração deve funcionar na maioria dos casos! 🚀