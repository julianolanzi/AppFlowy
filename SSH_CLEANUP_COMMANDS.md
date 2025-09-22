# 🧹 SSH CLEANUP COMMANDS - EasyPanel Docker Reset

## 🔐 **1. CONECTAR NO SERVIDOR**

```bash
# Conectar via SSH no seu servidor EasyPanel
ssh root@your-server-ip
# ou
ssh user@your-server-ip
```

## 🛑 **2. PARAR TODOS OS CONTAINERS**

```bash
# Parar TODOS os containers (inclui AppFlowy e outros)
docker stop $(docker ps -q)

# OU especificamente AppFlowy (se souber os nomes)
docker stop $(docker ps --filter "name=appflowy" --filter "name=postgres" --filter "name=redis" --filter "name=minio" --filter "name=gotrue" -q)
```

## 🗑️ **3. REMOVER CONTAINERS**

```bash
# Remover todos os containers parados
docker rm $(docker ps -aq)

# OU específico do AppFlowy
docker rm $(docker ps -a --filter "name=appflowy" --filter "name=postgres" --filter "name=redis" --filter "name=minio" --filter "name=gotrue" -q)
```

## 💾 **4. REMOVER VOLUMES (CRÍTICO!)**

```bash
# LISTAR volumes existentes primeiro
docker volume ls

# REMOVER volumes específicos do AppFlowy
docker volume rm $(docker volume ls --filter "name=appflowy" -q)
docker volume rm $(docker volume ls --filter "name=postgres" -q)
docker volume rm $(docker volume ls --filter "name=minio" -q)

# OU REMOVER TODOS os volumes não utilizados (CUIDADO!)
docker volume prune -f
```

## 🌐 **5. REMOVER NETWORKS**

```bash
# Remover networks não utilizadas
docker network prune -f

# OU remover network específica
docker network rm $(docker network ls --filter "name=appflowy" -q)
```

## 🖼️ **6. LIMPAR IMAGES (OPCIONAL)**

```bash
# Remover images não utilizadas
docker image prune -f

# OU remover images específicas do AppFlowy
docker rmi $(docker images --filter "reference=*appflowy*" -q)
docker rmi $(docker images --filter "reference=*gotrue*" -q)
```

## 💣 **7. LIMPEZA NUCLEAR (REMOVE TUDO!)**

```bash
# ⚠️ CUIDADO: Remove TUDO do Docker
docker system prune -a --volumes -f
```

## ✅ **8. VERIFICAR LIMPEZA**

```bash
# Verificar se não há containers rodando
docker ps

# Verificar se não há volumes
docker volume ls

# Verificar se não há networks customizadas
docker network ls

# Verificar espaço liberado
docker system df
```

## 🎯 **COMANDOS ESPECÍFICOS PARA APPFLOWY**

### Limpeza Segura (Recomendada):
```bash
# 1. Parar containers AppFlowy
docker stop $(docker ps --filter "name=english-appflowy" -q)

# 2. Remover containers AppFlowy
docker rm $(docker ps -a --filter "name=english-appflowy" -q)

# 3. Remover volumes AppFlowy
docker volume rm $(docker volume ls --filter "name=english-appflowy" -q)

# 4. Limpeza geral
docker system prune -f
```

### Limpeza Extrema (Se nada mais funcionar):
```bash
# Para TUDO e remove TUDO
docker stop $(docker ps -q) && docker rm $(docker ps -aq) && docker volume prune -f && docker system prune -a -f
```

## 🚀 **APÓS A LIMPEZA**

1. **Sair do SSH**: `exit`
2. **Ir no EasyPanel** e fazer deploy
3. **Monitorar logs** para ver se inicia limpo

## ⚠️ **DICAS IMPORTANTES**

- **BACKUP**: Se tiver dados importantes, faça backup antes
- **VERIFICAR**: Sempre rode `docker ps` antes para ver o que está rodando
- **ESPECÍFICO**: Use filtros por nome para não afetar outros projetos
- **PACIÊNCIA**: PostgreSQL pode levar 2-3 minutos para iniciar limpo

## 🔍 **TROUBLESHOOTING**

Se ainda der erro após limpeza:
```bash
# Verificar se há processos usando as portas
netstat -tulpn | grep :5432
netstat -tulpn | grep :8000

# Matar processos específicos se necessário
sudo kill -9 <PID>

# Reiniciar Docker daemon (último recurso)
sudo systemctl restart docker
```