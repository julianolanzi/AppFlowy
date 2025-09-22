# 🔧 EasyPanel Configuration Guide - AppFlowy Cloud Proxy

## 🌐 **PROBLEMA: URL NÃO FUNCIONA**

O AppFlowy Cloud está rodando na porta 8000, mas o EasyPanel não está roteando corretamente.

## ✅ **DIAGNÓSTICO**

### Status Atual:
- ✅ PostgreSQL: Funcionando  
- ✅ Redis: Funcionando
- ✅ MinIO: Funcionando
- ✅ GoTrue: Funcionando na porta 9999
- ✅ **AppFlowy Cloud: Funcionando na porta 8000**
- ❌ **Proxy EasyPanel: NÃO CONFIGURADO**

### Porta Exposta:
```yaml
appflowy_cloud:
  ports:
    - "8000:8000"  # ✅ Porta exposta corretamente
```

## 🎯 **SOLUÇÕES PARA EASYPANEL**

### **SOLUÇÃO 1: Configurar Domain/Service**

**No EasyPanel Dashboard:**

1. **🔹 Ir em "Services" → "Domains"**
2. **🔹 Clicar "Add Domain" ou "Configure Domain"**
3. **🔹 Configurar:**
   ```
   Domain: english-appflowy.g9awyq.easypanel.host
   Service: appflowy_cloud
   Port: 8000
   Path: /
   HTTPS: Enabled
   ```

### **SOLUÇÃO 2: Configurar Proxy Manual**

**Se não tiver interface gráfica, editar configuração:**

1. **🔹 Localizar arquivo de configuração do proxy**
2. **🔹 Adicionar configuração:**
   ```nginx
   server {
       listen 80;
       listen 443 ssl;
       server_name english-appflowy.g9awyq.easypanel.host;
       
       location / {
           proxy_pass http://appflowy_cloud:8000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
       
       location /ws/ {
           proxy_pass http://appflowy_cloud:8000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
       }
   }
   ```

### **SOLUÇÃO 3: Testar Acesso Direto**

**Via SSH no servidor:**
```bash
# Testar se AppFlowy responde
curl http://localhost:8000/api/health

# Testar se o container responde
curl http://appflowy_cloud:8000/api/health

# Verificar se porta está aberta
netstat -tulpn | grep :8000
```

### **SOLUÇÃO 4: Acessar via IP + Porta**

**Temporariamente, tente acessar:**
```
http://YOUR_SERVER_IP:8000
```

## 🛠️ **CONFIGURAÇÃO DE AMBIENTE**

**No EasyPanel, certifique-se de que as variáveis estão configuradas:**

```bash
APPFLOWY_BASE_URL=https://english-appflowy.g9awyq.easypanel.host
APPFLOWY_WEB_URL=https://english-appflowy.g9awyq.easypanel.host
APPFLOWY_WEBSOCKET_BASE_URL=wss://english-appflowy.g9awyq.easypanel.host/ws/v2
```

## 📋 **CHECKLIST DE TROUBLESHOOTING**

### ✅ **Containers Status:**
```bash
docker ps | grep appflowy_cloud
# Deve mostrar: Up X minutes, 0.0.0.0:8000->8000/tcp
```

### ✅ **Porta Aberta:**
```bash
netstat -tulpn | grep :8000
# Deve mostrar: tcp6 :::8000 :::* LISTEN
```

### ✅ **Serviço Respondendo:**
```bash
curl -I http://localhost:8000
# Deve retornar: HTTP/1.1 200 OK ou similar
```

### ✅ **DNS/Proxy:**
```bash
dig english-appflowy.g9awyq.easypanel.host
# Deve apontar para o IP do servidor
```

## 🚨 **PRÓXIMOS PASSOS**

1. **🔍 Verificar configuração de domínio no EasyPanel**
2. **⚙️ Configurar proxy para appflowy_cloud:8000**
3. **🧪 Testar acesso via IP:8000 primeiro**
4. **🔄 Reiniciar proxy/nginx se necessário**

## 📞 **COMANDOS DE DIAGNÓSTICO**

```bash
# 1. Verificar containers
docker ps

# 2. Verificar logs do AppFlowy
docker logs english_appflowy-appflowy_cloud-1

# 3. Testar resposta
curl http://localhost:8000/api/health

# 4. Verificar porta
ss -tulpn | grep :8000

# 5. Verificar proxy do EasyPanel
docker ps | grep proxy
docker ps | grep nginx
```

O **AppFlowy está 100% funcionando**, só precisa configurar o proxy no EasyPanel!